//
//  WWDCCollection.swift
//  WWDC
//
//  Created by Leon on 7/12/23.
//
//

import Foundation
import SwiftData


@Model public class WWDCCollection {
    var id: UUID?
    var isCollected: Bool?
    var lastUpdated: Date?
    
}
