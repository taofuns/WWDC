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
    var id: UUID?
    var isStared: Bool?
    var name: String?
    var number: String?
    var pdfURL: String?
    var preferURL: String?
    var sdURL: String?
    var year: String?

    init(hdURL: String? = nil, id: UUID? = nil, isStared: Bool? = nil, name: String? = nil, number: String? = nil, pdfURL: String? = nil, preferURL: String? = nil, sdURL: String? = nil, year: String? = nil) {
        self.hdURL = hdURL
        self.id = id
        self.isStared = isStared
        self.name = name
        self.number = number
        self.pdfURL = pdfURL
        self.preferURL = preferURL
        self.sdURL = sdURL
        self.year = year
    }

}
