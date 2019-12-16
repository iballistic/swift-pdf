//
//  contentgenerator.swift
//  pdfgenerator
//
//  Created by Telman Rustam on 2018-12-25.
//

import Foundation
import Stencil
public class TemplateEngine{
    private var template : Template
    public init(content : String){
        template = Template(templateString: content)
    }
    
    public func render(_ dictionary: [String: Any]? = nil) throws -> String {
        do {
         let content = try self.template.render(dictionary)
        return content
        }
        catch {
            throw error
        }
    
    }
    
}
