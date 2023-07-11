## CoreData

Entities `WWDCCollection` haven't use
don't know how to connect different entity

## SwiftUI


## Data Reset

Current basic logic is delete all sessions, and create new again, **but it will lose all the data.**

```swift
func deleteData() {
        for wwdcSession in wwdcSessions {
            moc.delete(wwdcSession)
            try? moc.save()
        }
    }
```

```swift
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
```
Better solution is compare the two data source, and only add or update the data.

anther problem needs to be solved is how to pass the funciton in SwiftUI

```swift
   struct dataRefresh: View {
        var body: some View {
            Button {
                ResultList(filter: "", year: "").deleteData()
                ResultList(filter: "", year: "").getData()
            } label: {
                Image(systemName: "arrow.clockwise.circle")
            }
        }

    }
    
    struct ContentView: View {
    
    @State private var searchText = ""
    @State private var selectedYear = ""
    
    
    var body: some View {
        NavigationView {
            VStack{
                ResultList(filter: searchText,year: selectedYear)
            }
            .toolbar{
                ResultList.dataRefresh()
                YearList(selectedYear: $selectedYear)
//                ToolbarItem(placement:.navigationBarLeading) {
//                    ResultList.dataRefresh()
//                }
//                ToolbarItem(placement:.navigationBarTrailing) {
//                    YearList(selectedYear: $selectedYear)
//                }
            }
            .navigationTitle(selectedYear == "" ? "WWDC" : "WWDC \(selectedYear)")
            .searchable(text: $searchText, prompt: selectedYear == "" ? "Search session in all year" : "Search session in \(selectedYear)")
        }
    }
    
}
    

```

## The Archetecture


