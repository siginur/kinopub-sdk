//
//  KPPoster.swift
//  
//
//  Created by Alexey Siginur on 04/02/2022.
//

import Foundation

public class KPPoster: Codable, Hashable, Identifiable, KPJsonRepresentable {
    
    public let small: URL
    public let medium: URL
    public let big: URL
    public let wide: URL?
    
    public required init(json: KPJson) throws {
        self.small = try json.parse(key: "small")
        self.medium = try json.parse(key: "medium")
        self.big = try json.parse(key: "big")
        self.wide = try? json.parse(key: "wide")
    }
    
    public init(small: URL, medium: URL, big: URL, wide: URL?) {
        self.small = small
        self.medium = medium
        self.big = big
        self.wide = wide
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(small)
        hasher.combine(medium)
        hasher.combine(big)
        hasher.combine(wide)
    }
    
    public static func == (lhs: KPPoster, rhs: KPPoster) -> Bool {
        return lhs.small == rhs.small &&
        lhs.medium == rhs.medium &&
        lhs.big == rhs.big &&
        lhs.wide == rhs.wide
    }
    
}
