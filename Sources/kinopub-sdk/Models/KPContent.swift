//
//  KPContent.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPContent: DecodableFromRawData {
    
    public let id: Int
    public let title: String
    public let type: String
    
    required init(raw: RawData) throws {
        self.id = try raw.parse(key: "id")
        self.type = try raw.parse(key: "type")
        self.title = try raw.parse(key: "title")
    }
    
}
