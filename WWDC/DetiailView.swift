//
//  DetiailView.swift
//  WWDC
//
//  Created by Leon on 2022/10/6.
//

import SwiftUI
import SwiftData


struct DetiailView: View {
    @Bindable var session: WWDCSession
    @State var currentPage = "PDF"
    @Environment(\.openURL) var openURL
    @Environment(\.modelContext) private var modelContext
    @State var thisStar = false
    @State var isShowInspector = false

    
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
//                    PlayerView(url: url)
                    WebView(url: url)
                }
            } else {
                if let pdfUrl = session.pdfURL, let url = URL(string: pdfUrl) {
//                    PDFPresentView(url: url)
                    WebView(url: url)
                }
            }
        }
        .inspector(isPresented: $isShowInspector) {
            // TODO: typing not fluently
//            TextEditor(text: $session.note)
//                .font(.body)
            WWDCNotesView(session: session)
        }
        .toolbar(content: {
            ToolbarItem(placement: .automatic) {
                Image(systemName: thisStar ? "star.fill" : "star")
                    .onTapGesture {
                        session.isStared?.toggle()
                        try? modelContext.save()
                        thisStar = session.isStared!

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
            if let videoUrl = session.preferURL{
                ToolbarItem(placement: .automatic) {
                    Image(systemName: "rectangle.stack.badge.play")
                        .onTapGesture {
                            openURL(URL(string: videoUrl)!)
                        }
                }
            }
            ToolbarItem(placement: .automatic) {
                Image(systemName: "pencil.and.list.clipboard")
                    .onTapGesture {
                        isShowInspector.toggle()
                    }
            }



        })
        .onAppear {
            if let isStared = session.isStared {
                thisStar = isStared
            }
            if session.pdfURL == nil {
                currentPage = "VIDEO"
            }
        }
    }

//    private func downloadFile(from urlString: String, to folderURL: URL,filename: String,year:String) {
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//
//        let task = URLSession.shared.downloadTask(with: url) { location, response, error in
//            guard let location = location else {
//                print("Download error: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            let fileName = filename
////            let fileExtension = url.pathExtension
//            let subfolderURL = folderURL.appendingPathComponent(year, isDirectory: true)
//
//            do {
//                // 如果子文件夹不存在，创建子文件夹
//                if !FileManager.default.fileExists(atPath: subfolderURL.path) {
//                    try FileManager.default.createDirectory(at: subfolderURL, withIntermediateDirectories: true, attributes: nil)
//                }
//
//                let destinationURL = subfolderURL.appendingPathComponent(fileName)
//
//                // 如果目标路径已经有相同的文件，提示用户文件已存在
//                if FileManager.default.fileExists(atPath: destinationURL.path) {
//                    print("File already exists at \(destinationURL)")
//                } else {
//                    // 将下载的文件保存到指定的文件夹
//                    try FileManager.default.moveItem(at: location, to: destinationURL)
//                    print("File downloaded and saved at \(destinationURL)")
//                }
//            } catch {
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//
//        task.resume()
//    }

}
