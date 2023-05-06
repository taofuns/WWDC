//
//  WWDCApp.swift
//  WWDC
//
//  Created by Leon on 2022/10/2.
//

import SwiftUI

//#if os(macOS)

@main
struct WWDCApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
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
