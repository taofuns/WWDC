//
//  SourceAnalyze.swift
//  WWDC
//
//  Created by Leon on 2022/10/2.
//

import Foundation


struct SourceAnalyze {
    struct WWDCSession {
        var id: UUID
        var year: String
        var number: String
        var name: String
        var hdURL: String?
        var sdURL: String?
        var pdfURL: String?
        var preferURL: String? {
            if hdURL != nil {
                return hdURL
            } else {
                return sdURL
            }
        }
    }
    
    static let source = Bundle.main.url(forResource: "WWDCSource", withExtension: "txt")!
    
    static let regexOld = /- Session (?<number>\d+) · (?<name>[^\[]*)(?:(?=\[hd\])\[hd\]\((?<hdURL>.*?)(?=(?:\)\s\|\s\[sd)|(?:\)\s\|\s\[pdf)|(?:\)))\))*(?:\s*\|\s*)*(?:(?=\[sd\])\[sd\]\((?<sdURL>.*?)(?=(?:\)\s*\|\s*\[pdf)|(?:\)))\))*(?:\s*\|\s*)*(?:(?:(?=\[pdf\])\[pdf\]\((?<pdfURL>.*?)(?=\)))*\))*/
    
    static let regexNew = /- Session (?<number>\d+) · (?<name>[^\[]*)(?:(?=\[sd\])\[sd\]\((?<sdURL>.*?)(?=(?:\)\s\|\s\[hd)|(?:\)\s\|\s\[pdf)|(?:\)))\))*(?:\s*\|\s*)*(?:(?=\[hd\])\[hd\]\((?<hdURL>.*?)(?=(?:\)\s*\|\s*\[pdf)|(?:\)))\))*(?:\s*\|\s*)*(?:(?:(?=\[pdf\])\[pdf\]\((?<pdfURL>.*?)(?=\)))*\))*/

    static let regexNew2 = /(?<sdURL>http.*)\n\s+out=\[\d+]\s+\[Session\s+(?<number>\d+)\]\s(?<name>.*)\n/
    
    static let regexToFindYear = /# WWDC (?<year>\d{4})/
    
    static func getData(fromSource: URL) throws -> Array<WWDCSession> {
        
        var sessions = [WWDCSession]()
        
        guard let contents = try? String(contentsOf:fromSource) else {
            throw SourceAnalyzeError.invalidSource
        }
        
        let contentByYear = contents.components(separatedBy: "---")
        
        for content in contentByYear {
            
            guard let matchedYear = content.firstMatch(of: regexToFindYear)?.year else {
                throw SourceAnalyzeError.noMatchedYear
            }


            if ["2009","2010","2011","2012","2013","2014"].contains(matchedYear) {
                let matches = content.matches(of: regexOld)
                
                for m in matches {
                    let id = UUID()
                    let year = String(matchedYear)
                    let name = String(m.name)
                    let number = String(m.number)
                    var hdURL: String? = nil
                    var sdURL: String? = nil
                    var pdfURL: String? = nil
                    
                    if let mhdURL = m.hdURL {
                        hdURL = String(mhdURL)
                    }
                    
                    if let msdURL = m.sdURL {
                        sdURL = String(msdURL)
                    }
                    
                    if let mpdfURL = m.pdfURL {
                        pdfURL = String(mpdfURL)
                    }
                    
                    let session = WWDCSession(id: id, year: year, number: number, name: name,hdURL: hdURL,sdURL: sdURL,pdfURL: pdfURL)
                    sessions.append(session)
                }
            } else if ["2015","2016","2017","2018","2019","2020","2021"].contains(matchedYear) {
                let matches = content.matches(of: regexNew)
                
                for m in matches {
                    let id = UUID()
                    let year = String(matchedYear)
                    let name = String(m.name)
                    let number = String(m.number)
                    var hdURL: String? = nil
                    var sdURL: String? = nil
                    var pdfURL: String? = nil
                    
                    if let mhdURL = m.hdURL {
                        hdURL = String(mhdURL)
                    }
                    
                    if let msdURL = m.sdURL {
                        sdURL = String(msdURL)
                    }
                    
                    if let mpdfURL = m.pdfURL {
                        pdfURL = String(mpdfURL)
                    }
                    
                    let session = WWDCSession(id: id, year: year, number: number, name: name,hdURL: hdURL,sdURL: sdURL,pdfURL: pdfURL)
                    sessions.append(session)
                }
            } else {
                let matches = content.matches(of: regexNew2)

                for m in matches {
                    let id = UUID()
                    let year = String(matchedYear)
                    let name = String(m.name)
                    let number = String(m.number)
                    let hdURL: String? = nil
                    var sdURL: String? = nil
                    let pdfURL: String? = nil

                    sdURL = String(m.sdURL)


                    let session = WWDCSession(id: id, year: year, number: number, name: name,hdURL: hdURL,sdURL: sdURL,pdfURL: pdfURL)
                    sessions.append(session)
                }
            }
        }
        return sessions
    }
    
    enum SourceAnalyzeError: Error {
        case invalidSource
        case noMatchedYear
    }
}
