//
//  ContentView.swift
//  WWDC
//
//  Created by Leon on 2022/10/2.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedYear: String?
    @State private var showStared = false

    var body: some View {
        NavigationSplitView {
            VStack {
                YearList(selectedYear: $selectedYear, showStared: $showStared)
                UpdateView()
            }
            .navigationTitle("WWDC Pro")

        } content: {
            if let selectedYear {
                ResultList(filter: searchText, year: selectedYear, showStared: $showStared)
                    .searchable(text: $searchText, prompt: selectedYear != "" ?  "Search session in \(selectedYear)" : "Search session in all year")
                    .navigationTitle("Sessions \(selectedYear)")
            } else {
                ResultList(filter: searchText, year: "", showStared: $showStared)
                    .searchable(text: $searchText, prompt: "search from bookmark")
                    .navigationTitle("Bookmark")
            }

        } detail: {
            Text("no selected")
        }
    }
}

struct YearList: View {
    @Binding var selectedYear: String?
    @Binding var showStared: Bool

    let yearList = ["", "2023", "2022", "2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008", "2007"]
    var body: some View {

        List(selection: $selectedYear) {
            Section() {
                Button("\(Image(systemName: showStared ? "star.fill" : "star"))Bookmark") {
                    showStared.toggle()
                }.buttonStyle(.plain)
            }
            Section("Year") {
                ForEach(yearList, id: \.self) { year in
                    Text(year != "" ? year : "All Year")
                }
            }
        }

    }
}

struct UpdateView: View {
    @Query var wwdcSessions: [WWDCSession]
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        Button("\(Image(systemName: "goforward")) Reload data") {
            for wwdcSession in wwdcSessions {
                modelContext.delete(wwdcSession)
            }
            // TODO: - can not just upsert
            getData()
        }
        .buttonStyle(.borderless)
        .padding()
    }

    func getData() {
        do {
            let sessions = try SourceAnalyze.getData(fromSource: SourceAnalyze.source)
            for session in sessions {
                let wwdcSession = WWDCSession()
                wwdcSession.idc = session.id
                wwdcSession.year = session.year
                wwdcSession.number = session.number
                wwdcSession.name = session.name
                wwdcSession.sdURL = session.sdURL
                wwdcSession.hdURL = session.hdURL
                wwdcSession.pdfURL = session.pdfURL
                wwdcSession.preferURL = session.preferURL
                modelContext.insert(wwdcSession)
            }
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}

struct ResultList: View {
    @Query var wwdcSessions: [WWDCSession]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List(wwdcSessions) { wwdcSession in
            NavigationLink {
                DetiailView(session: wwdcSession)
                    .navigationTitle(wwdcSession.name ?? "unknown")
                #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                #endif
            } label: {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom, spacing: 3) {
                        Text("\(wwdcSession.year ?? "")-\(wwdcSession.number ?? "")")
                        if wwdcSession.isStared == true {
                            Image(systemName: "star.fill")
                        }
                        if wwdcSession.preferURL != nil {
                            Image(systemName: "play.circle")
                        }
                        if wwdcSession.pdfURL != nil {
                            Image(systemName: "doc.circle")
                        }
                    }
                    .font(.caption)
                    Text(wwdcSession.name ?? "unkown")
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(5)
                }
            }
        }

        .onAppear {
            if wwdcSessions.isEmpty {
                getData()
            }
        }
    }

    func getData() {
        do {
            let sessions = try SourceAnalyze.getData(fromSource: SourceAnalyze.source)
            for session in sessions {
                let wwdcSession = WWDCSession()
                wwdcSession.idc = session.id
                wwdcSession.year = session.year
                wwdcSession.number = session.number
                wwdcSession.name = session.name
                wwdcSession.sdURL = session.sdURL
                wwdcSession.hdURL = session.hdURL
                wwdcSession.pdfURL = session.pdfURL
                wwdcSession.preferURL = session.preferURL
                modelContext.insert(wwdcSession)
            }
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    init(filter: String, year: String, showStared: Binding<Bool>) {
        var queryDescriptor = FetchDescriptor<WWDCSession>()
        queryDescriptor.sortBy = [SortDescriptor(\.year, order: .reverse), SortDescriptor(\.number)]
        if showStared.wrappedValue {
            // TODO: if no started, this will crash
            let predicate = #Predicate<WWDCSession> { session in
                session.isStared == true
            }
            queryDescriptor.predicate = predicate
        } else {
            if year.isEmpty {
                if filter.isEmpty {
                } else {
                    let predicate = #Predicate<WWDCSession> { session in
                        session.name?.localizedStandardContains(filter) ?? false
                    }

                    queryDescriptor.predicate = predicate
                }
            } else {
                if filter.isEmpty {
                    let predicate = #Predicate<WWDCSession> { session in
                        session.year == year
                    }

                    queryDescriptor.predicate = predicate

                } else {
                    let predicate = #Predicate<WWDCSession> { session in
                        (session.name?.localizedStandardContains(filter) ?? false) && (session.year == year)
                    }

                    queryDescriptor.predicate = predicate
                }
            }
        }
        _wwdcSessions = Query(queryDescriptor)
    }
}

//
// #Preview {
////    MainActor.assumeIsolated {
//        ContentView()
//            .modelContainer(for: WWDCSession.self)
//    }
// }

// #Preview {
//    MainActor.assumeIsolated {
//        let container = try! ModelContainer(for: WWDCSession.self)
//
//        return
//            (ContentView()
//                .modelContainer(container))
//
//    }
// }
