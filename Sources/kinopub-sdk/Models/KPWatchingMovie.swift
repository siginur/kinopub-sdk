//
//  KPWatchingMovie.swift
//  
//
//  Created by Alexey Siginur on 28/01/2022.
//

import Foundation

public class KPWatchingMovie: KPContent {
    
    public let subtype: String
    public let poster: Poster
    
    required init(raw: RawData) throws {
        self.subtype = try raw.parse(key: "subtype")
        self.poster = try raw.parse(key: "posters")
        try super.init(raw: raw)
    }
    
    public init(id: Int, title: String, type: String, subtype: String, poster: Poster) {
        self.subtype = subtype
        self.poster = poster
        super.init(id: id, title: title, type: type)
    }
    
    private enum Key: CodingKey {
        case subtype, poster
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.subtype = try container.decode(String.self, forKey: .subtype)
        self.poster = try container.decode(Poster.self, forKey: .poster)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(subtype, forKey: .subtype)
        try container.encode(poster, forKey: .poster)
        try super.encode(to: encoder)
    }
    
    public static func == (lhs: KPWatchingMovie, rhs: KPWatchingMovie) -> Bool {
        return lhs as KPContent == rhs as KPContent &&
        lhs.subtype == rhs.subtype &&
        lhs.poster == rhs.poster
    }
    
}

public extension KPWatchingMovie {

    class Poster: Codable, Equatable, DecodableFromRawData {
        public let small: URL?
        public let medium: URL?
        public let big: URL?
        
        internal required init(raw: RawData) throws {
            self.small = try? raw.parse(key: "small")
            self.medium = try? raw.parse(key: "medium")
            self.big = try? raw.parse(key: "big")
        }
        
        public init(small: URL?, medium: URL?, big: URL?) {
            self.small = small
            self.medium = medium
            self.big = big
        }
        
        public static func == (lhs: KPWatchingMovie.Poster, rhs: KPWatchingMovie.Poster) -> Bool {
            return lhs.small == rhs.small &&
            lhs.medium == rhs.medium &&
            lhs.big == rhs.big
        }
    }
    
}
