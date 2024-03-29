//
//  WWDCSession.swift
//  WWDC
//
//  Created by Leon on 7/12/23.
//
//

import Foundation
import SwiftData


@Model public class WWDCSession {
    var hdURL: String?
    @Attribute(.unique) var idc: UUID? // when migrating from CoreData to SwiftData, can't use `id` any more
    var isStared: Bool?
    var name: String?
    var number: String?
    var pdfURL: String?
    var preferURL: String?
    var sdURL: String?
    var year: String?

    var note: String

    @Attribute(.unique) var sessionID: String {
        "\(year!)-\(number!)"
    }

    init(hdURL: String? = nil, idc: UUID? = nil, isStared: Bool? = false, name: String? = nil, number: String? = nil, pdfURL: String? = nil, preferURL: String? = nil, sdURL: String? = nil, year: String? = nil) {
        self.hdURL = hdURL
        self.idc = idc
        self.isStared = isStared
        self.name = name
        self.number = number
        self.pdfURL = pdfURL
        self.preferURL = preferURL
        self.sdURL = sdURL
        self.year = year
        self.note = ""
    }
}
