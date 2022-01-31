//
//  KPContent.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPContent: Codable, Equatable, KPJsonRepresentable {
    
    public let id: Int
    public let title: String
    public let type: String
    
    public required init(json: KPJson) throws {
        self.id = try json.parse(key: "id")
        self.type = try json.parse(key: "type")
        self.title = try json.parse(key: "title")
    }
    
    public init(id: Int, title: String, type: String) {
        self.id = id
        self.title = title
        self.type = type
    }
    
    public static func == (lhs: KPContent, rhs: KPContent) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.type == rhs.type
    }
    
}
