//
//  KPBookmarkFolder.swift
//  
//
//  Created by Alexey Siginur on 11/10/2023.
//

import Foundation

public class KPBookmarkFolder: Codable, Hashable, Identifiable, KPJsonRepresentable {
    
    public let id: Int
    public let title: String
    public let views: Int
    public let count: Int
    public let created: Date
    public let updated: Date
    
    public required init(json: KPJson) throws {
        id = try json.parse(key: "id")
        title = try json.parse(key: "title")
        views = try json.parse(key: "views")
        created = try json.parse(key: "created")
        updated = try json.parse(key: "updated")

        let countString: String = try json.parse(key: "count")
        guard let count = Int(countString) else {
            throw ParsingError.conversion(key: "count", sourceType: "String", targetType: "Int")
        }
        self.count = count
    }
    
    public init(id: Int, title: String, views: Int, count: Int, created: Date, updated: Date) {
        self.id = id
        self.title = title
        self.views = views
        self.count = count
        self.created = created
        self.updated = updated
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(views)
        hasher.combine(count)
        hasher.combine(created)
        hasher.combine(updated)
    }
    
    public static func == (lhs: KPBookmarkFolder, rhs: KPBookmarkFolder) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.views == rhs.views &&
        lhs.count == rhs.count &&
        lhs.created == rhs.created &&
        lhs.updated == rhs.updated
    }
    
}
