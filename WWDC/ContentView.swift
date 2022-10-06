//
//  ContentView.swift
//  WWDC
//
//  Created by Leon on 2022/10/2.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchText = ""
    @State private var selectedYear = ""
    
    
    var body: some View {
        NavigationView {
            VStack{
                ResultList(filter: searchText,year: selectedYear)
            }
            .toolbar{
                YearList(selectedYear: $selectedYear)
            }
            .navigationTitle(selectedYear == "" ? "WWDC" : "WWDC \(selectedYear)")
            .searchable(text: $searchText, prompt: selectedYear == "" ? "Search session in all year" : "Search session in \(selectedYear)")
        }
    }
    
}

struct YearList: View {
    @Binding var selectedYear: String
    let yearList = ["","2021","2020","2019","2018","2017","2016","2015","2014","2013","2012","2011","2010","2009"]
    var body: some View {
        HStack(spacing:0) {
            Picker("Year", selection: $selectedYear) {
                ForEach(yearList,id: \.self) { year in
                    Text(year != "" ? year : "All Year")
                }
                
            }
        }
    }
}

struct ResultList: View {

    @FetchRequest var wwdcSessions: FetchedResults<WWDCSession>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        List(wwdcSessions) {wwdcSession in
            VStack(alignment: .leading){
                HStack(alignment: .bottom,spacing: 3) {
                    Text("\(wwdcSession.year ?? "")-\(wwdcSession.number ?? "")")
                    if wwdcSession.preferURL != nil {
                        Image(systemName: "play.circle")
                    }
                    if wwdcSession.pdfURL != nil {
                        Image(systemName: "doc.circle")
                    }
                }
                .font(.caption)
                Text(wwdcSession.name ?? "unkown")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .onTapGesture {
                if let preferURL = wwdcSession.preferURL, let url = URL(string: preferURL) {
                    UIApplication.shared.open(url)
                }
            }
            .onLongPressGesture {
                if let pdfURL = wwdcSession.pdfURL, let url = URL(string: pdfURL) {
                    UIApplication.shared.open(url)
                }
            }
        }
        .onAppear{
            if wwdcSessions.isEmpty {
                getData()
            }
        }
    }
    
    func getData(){
        do {
            let sessions = try SourceAnalyze.getData(fromSource: SourceAnalyze.source)
            for session in sessions {
                let wwdcSession = WWDCSession(context: moc)
                wwdcSession.id = session.id
                wwdcSession.year = session.year
                wwdcSession.number = session.number
                wwdcSession.name = session.name
                wwdcSession.sdURL = session.sdURL
                wwdcSession.hdURL = session.hdURL
                wwdcSession.pdfURL = session.pdfURL
                wwdcSession.preferURL = session.preferURL
                try? moc.save()
            }
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    init(filter: String, year: String) {
        if year.isEmpty {
            if filter.isEmpty {
                _wwdcSessions = FetchRequest<WWDCSession>(sortDescriptors: [SortDescriptor(\.year,order:.reverse),SortDescriptor(\.number)])
            } else {
                _wwdcSessions = FetchRequest<WWDCSession>(sortDescriptors: [SortDescriptor(\.year,order:.reverse),SortDescriptor(\.number)],predicate: NSPredicate(format: "name CONTAINS[cd] %@", filter))
            }
        } else {
            if filter.isEmpty {
                _wwdcSessions = FetchRequest<WWDCSession>(sortDescriptors: [SortDescriptor(\.year,order:.reverse),SortDescriptor(\.number)],predicate: NSPredicate(format: "year == %@", year))
            } else {
                let filterPro = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "name CONTAINS[cd] %@", filter),NSPredicate(format: "year == %@", year)])
                _wwdcSessions = FetchRequest<WWDCSession>(sortDescriptors: [SortDescriptor(\.year,order:.reverse),SortDescriptor(\.number)],predicate: filterPro)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
