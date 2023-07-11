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
    var idc: UUID
    var isCollected: Bool?
    var lastUpdated: Date?

    init(id: UUID, isCollected: Bool? = nil, lastUpdated: Date? = nil) {
        self.idc = id
        self.isCollected = isCollected
        self.lastUpdated = lastUpdated
    }
}
