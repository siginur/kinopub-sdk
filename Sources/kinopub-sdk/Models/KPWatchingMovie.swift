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
    
}

public extension KPWatchingMovie {

    class Poster: DecodableFromRawData {
        public let small: URL?
        public let medium: URL?
        public let big: URL?
        
        required init(raw: RawData) throws {
            self.small = try? raw.parse(key: "small")
            self.medium = try? raw.parse(key: "medium")
            self.big = try? raw.parse(key: "big")
        }
    }
    
}
