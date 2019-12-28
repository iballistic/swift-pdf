
//
//  PdfGenerator.swift
//  pdfgenerator
//
//  Created by Telman Rustam on 2018-12-25.
//  Copyright © 2018 com.iballistic. All rights reserved.
//

import Foundation
import UIKit

let defaultResolution: Int = 72

public class PDFGenerator {
    
    //default paper size look up hash
    public enum Size{
        case A4
        case Letter
    }
    private let dimensions = [
        Size.A4 : (width: 595.2, height: 841.8),
        Size.Letter : (width: 612, height: 792)
    ]
    private var pageSize : CGSize
    private var pageMargins : UIEdgeInsets
    
    
    public enum Paper{
        case Standard(Size)
        case Custom(Double, Double)
        
    }
    
    /// Set paper size
    public var paperSize : Paper{
        willSet {
            switch newValue {
            case .Custom(let width, let height):
                self.pageSize = CGSize(width: width, height: height)
            case .Standard(let standard):
                self.pageSize = CGSize(width: (self.dimensions[standard]?.width)!,
                                       height : (self.dimensions[standard]?.height)!)
            }
        }
    }
    
    /// Set page margin
    public var margin : (top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)?{
        willSet{
            self.pageMargins = UIEdgeInsets(top: newValue?.top ?? 0, left: newValue?.left ?? 0, bottom: newValue?.bottom ?? 0, right: newValue?.right ?? 0)
        }
    }
    
    public init() {
        pageSize = CGSize(width: (self.dimensions[PDFGenerator.Size.Letter]?.width)!, height: (self.dimensions[PDFGenerator.Size.Letter]?.height)!)
        
        pageMargins = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
        //the default is set to the letter size
        self.paperSize = Paper.Standard(PDFGenerator.Size.Letter)
        self.margin = (top: 72, left: 72, bottom: 72, right: 72)
    }
    

    @objc public func render(content: String)-> NSMutableData?{
        //let attributedString = NSAttributedString(string: content, attributes: [NSAttributedString.Key.backgroundColor : UIColor.lightText])
        //let printFormatter = UISimpleTextPrintFormatter(attributedText: attributedString)
        let printFormatter = UIMarkupTextPrintFormatter(markupText: content)
        return self.render(printFormatter: printFormatter)
    }
    
    
    //https://www.hackingwithswift.com/example-code/uikit/how-to-render-an-nsattributedstring-to-a-pdf
    //https://github.com/bvankuik/TestMakeAndPrintPDF/blob/master/TestMakeAndPrintPDF/PreviewViewController.swift
    //https://developer.apple.com/documentation/uikit/uigraphicspdfrenderer#2863996
    @objc public func render(printFormatter: UIPrintFormatter)-> NSMutableData?{
        let renderer = UIPrintPageRenderer()
        renderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        // calculate the printable rect from the above two
        let printableRect = CGRect(x: pageMargins.left, y: pageMargins.top, width: pageSize.width - pageMargins.left - pageMargins.right, height: pageSize.height - pageMargins.top - pageMargins.bottom)
        // and here's the overall paper rectangle
        let paperRect = CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)
        renderer.setValue(NSValue(cgRect: paperRect), forKey: "paperRect")
        renderer.setValue(NSValue(cgRect: printableRect), forKey: "printableRect")
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, paperRect, nil)
        renderer.prepare(forDrawingPages: NSMakeRange(0, renderer.numberOfPages))
        let bounds = UIGraphicsGetPDFContextBounds()
        
        for i in 0  ..< renderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            
            renderer.drawPage(at: i, in: bounds)
        }
        
        UIGraphicsEndPDFContext()
        
        return pdfData
    }
    
    public func write(to: URL, pdfData : NSMutableData?){
        do {
            try pdfData?.write(to: to)
        } catch {
            print(error.localizedDescription)
        }
    }
}


