//
//  DetiailView.swift
//  WWDC
//
//  Created by Leon on 2022/10/6.
//

import SwiftUI


struct DetiailView: View {
    var session: FetchedResults<WWDCSession>.Element
    @State var currentPage = "PDF"
    @Environment(\.openURL) var openURL
    @Environment(\.managedObjectContext) var moc
    @State var thisStar = false

    
    var body: some View {
        
        VStack{
            if session.pdfURL != nil {
                Picker("", selection: $currentPage) {
                    ForEach(["PDF","VIDEO"],id: \.self) {
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
        .toolbar(content: {
            if let videoUrl = session.preferURL{
                ToolbarItem(placement: .automatic) {
                    Image(systemName: "rectangle.stack.badge.play")
                        .onTapGesture {
                            openURL(URL(string: videoUrl)!)
                        }
                }
            }
            if let pdfUrl = session.pdfURL {
                ToolbarItem(placement: .automatic) {
                    Image(systemName: "newspaper")
                        .onTapGesture {
                            openURL(URL(string: pdfUrl)!)
                        }
                }
            }
            ToolbarItem(placement: .automatic) {
                Image(systemName: thisStar ? "star.fill" : "star")
                    .onTapGesture {
                        session.isStared.toggle()
                        try? moc.save()
                        thisStar = session.isStared

                    }
            }

        })
        .onAppear {
            thisStar = session.isStared
            if session.pdfURL == nil {
                currentPage = "VIDEO"
            }
        }
    }
}
