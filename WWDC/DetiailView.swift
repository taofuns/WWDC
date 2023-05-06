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
            ToolbarItem(placement: .navigation) {
                Image(systemName: thisStar ? "star.fill" : "star")
                    .onTapGesture {
                        session.isStared.toggle()
                        try? moc.save()
                        thisStar = session.isStared

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
                ToolbarItem(placement: .automatic) {
                    Image(systemName: "square.and.arrow.down")
                        .onTapGesture {
                            if let folderData = UserDefaults.standard.data(forKey: "defaultDownloadFolder"),
                               let folderURL = try? URL(dataRepresentation: folderData, relativeTo: nil) {
                                downloadFile(from: videoUrl, to: folderURL,filename: session.name!,year: session.year!)
                            } else {

                                print("Default download folder not set")
                            }
                        }
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

    private func downloadFile(from urlString: String, to folderURL: URL,filename: String,year:String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.downloadTask(with: url) { location, response, error in
            guard let location = location else {
                print("Download error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let fileName = filename
//            let fileExtension = url.pathExtension
            let subfolderURL = folderURL.appendingPathComponent(year, isDirectory: true)

            do {
                // 如果子文件夹不存在，创建子文件夹
                if !FileManager.default.fileExists(atPath: subfolderURL.path) {
                    try FileManager.default.createDirectory(at: subfolderURL, withIntermediateDirectories: true, attributes: nil)
                }

                let destinationURL = subfolderURL.appendingPathComponent(fileName)

                // 如果目标路径已经有相同的文件，提示用户文件已存在
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    print("File already exists at \(destinationURL)")
                } else {
                    // 将下载的文件保存到指定的文件夹
                    try FileManager.default.moveItem(at: location, to: destinationURL)
                    print("File downloaded and saved at \(destinationURL)")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

}
