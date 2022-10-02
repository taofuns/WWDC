//
//  WWDCApp.swift
//  WWDC
//
//  Created by Leon on 2022/10/2.
//

import SwiftUI

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
