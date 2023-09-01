//
//  AppSettingView.swift
//  WWDC
//
//  Created by Leon on 4/27/23.
//


#if os(macOS)
import SwiftUI

struct AppSettingsView: View {
    @AppStorage("defaultDownloadFolder", store: UserDefaults.standard) var defaultDownloadFolderData: Data?

    var body: some View {
        VStack {
            Button("Set Default Download Folder") {
                setDefaultDownloadFolder()
            }
        }
        .padding()
        .frame(width: 300, height: 200)
    }


    private func setDefaultDownloadFolder() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.prompt = "Choose Folder"

        panel.begin { response in
            if response == .OK {
                guard let folderURL = panel.urls.first else { return }
                UserDefaults.standard.set(try! Data(contentsOf: folderURL), forKey: "defaultDownloadFolder")
//                defaultDownloadFolderData = try? Data(contentsOf: folderURL)
                print("Default download folder set to: \(folderURL)")
                print(UserDefaults.standard.data(forKey: "defaultDownloadFolder"))
            }
        }
    }

}


struct AppSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView()
    }
}
#endif
