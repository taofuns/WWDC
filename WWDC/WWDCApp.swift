//
//  WWDCApp.swift
//  WWDC
//
//  Created by Leon on 2022/10/2.
//

import SwiftUI
import SwiftData

//#if os(macOS)

@main
struct WWDCApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: WWDCSession.self)
        }
    }
}
//#else
//
//@main
//struct WWDCApp: App {
//    @StateObject private var dataController = DataController()
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, dataController.container.viewContext)
//        }
//        .commands {
//            CommandGroup(replacing: .appSettings) {
//                AppSettingsView()
//            }.keyboardShortcut(",", modifiers: .command)
//        }
//    }
//}
//#endif
