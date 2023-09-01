//
//  PDFView.swift
//  WWDC
//
//  Created by Leon on 7/18/23.
//

//need to tranfer from UIkit and AppKit

import SwiftUI
import PDFKit

//#if os(macOS)
//import AppKit
//typealias ViewRepresentable = NSViewRepresentable
//#endif
//
//#if os(iOS)
//import UIKit
//typealias ViewRepresentable = UIViewRepresentable
//#endif


#if os(iOS)

struct PDFPresentView: UIViewRepresentable {
    let url:URL

    func makeUIView(context: Context) -> PDFView {
        let doc = PDFDocument(url: url)
        let view = PDFView()
        view.autoScales = true
        view.document = doc
        return view
    }

    func updateUIView(_ nsView: PDFView, context: Context) {

    }

}
#endif

#if os(macOS)

struct PDFPresentView: NSViewRepresentable {
    let url:URL

    func makeNSView(context: Context) -> PDFView {
        let doc = PDFDocument(url: url)
        let view = PDFView()
        view.autoScales = true
        view.document = doc
        return view
    }
    
    func updateNSView(_ nsView: PDFView, context: Context) {

    }
    
    
    typealias NSViewType = PDFView

    

}
#endif

