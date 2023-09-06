//
//  WWDCNotesView.swift
//  WWDC
//
//  Created by Leon on 9/7/23.
//

import SwiftUI

struct WWDCNotesView: View {
    @Bindable var session: WWDCSession
    var wwdcNotesUrl: URL {
        let baseurl = "https://www.wwdcnotes.com/notes/wwdc"
        let year = String(session.year?.suffix(2) ?? "21")
        let sessionID = session.number ?? "101"
        let url = "\(baseurl)\(year)/\(sessionID)/"
        return URL(string: url)!
    }

    var body: some View {
        VStack{
            Text(wwdcNotesUrl.description)
            WebView(url: wwdcNotesUrl)
        }.padding()

    }
}

//#Preview {
//    WWDCNotesView()
//}
