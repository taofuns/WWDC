//
//  DetiailView.swift
//  WWDC
//
//  Created by Leon on 2022/10/6.
//

import SwiftUI

struct DetiailView: View {
    var session: FetchedResults<WWDCSession>.Element
    @State var currentPage = "VIDEO"
    
    var body: some View {
        
        VStack{
            if session.pdfURL != nil {
                Picker("", selection: $currentPage) {
                    ForEach(["VIDEO","PDF"],id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.segmented)
            }
            if currentPage == "VIDEO" {
                if let videoUrl = session.preferURL, let url = URL(string: videoUrl) {
                    WebView(url: url)
                }
            } else {
                if let pdfUrl = session.pdfURL, let url = URL(string: pdfUrl) {
                    WebView(url: url)
                }
            }
        }
    }
}
