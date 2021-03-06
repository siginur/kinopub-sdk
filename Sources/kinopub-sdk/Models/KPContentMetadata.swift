//
//  KPMetadata.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPContentMetadata: Codable, Hashable, Identifiable, KPJsonRepresentable {
    
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
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(type)
    }
    
    public static func == (lhs: KPContentMetadata, rhs: KPContentMetadata) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.type == rhs.type
    }
    
}
