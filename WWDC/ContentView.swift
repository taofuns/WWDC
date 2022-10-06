//
//  ContentView.swift
//  WWDC
//
//  Created by Leon on 2022/10/2.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchText=""
    
    var body: some View {
        NavigationView {
            VStack{
                FetchList(filter: searchText)
            }
            .navigationTitle("WWDC")
            .searchable(text: $searchText, prompt: "Search session")
        }
    }
    
}


struct FetchList: View {
    
    
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
    
    init(filter: String) {
        if filter.isEmpty {
            _wwdcSessions = FetchRequest<WWDCSession>(sortDescriptors: [SortDescriptor(\.year,order:.reverse),SortDescriptor(\.number)])
        } else {
            _wwdcSessions = FetchRequest<WWDCSession>(sortDescriptors: [SortDescriptor(\.year,order:.reverse),SortDescriptor(\.number)],predicate: NSPredicate(format: "name CONTAINS[cd] %@", filter))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
