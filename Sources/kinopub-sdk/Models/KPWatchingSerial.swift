//
//  KPWatchingSerial.swift
//  
//
//  Created by Alexey Siginur on 28/01/2022.
//

import Foundation

public class KPWatchingSerial: KPWatchingMovie, CouldBeInWatchList {
    
    public let watched: Int
    public let new: Int
    public var total: Int { return watched + new }

    required init(raw: RawData) throws {
        self.watched = try raw.parse(key: "watched")
        self.new = try raw.parse(key: "new")
        try super.init(raw: raw)
    }
    
}
