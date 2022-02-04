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

    public required init(json: KPJson) throws {
        self.watched = try json.parse(key: "watched")
        self.new = try json.parse(key: "new")
        try super.init(json: json)
    }
    
    public init(id: Int, title: String, type: String, subtype: String, poster: KPPoster, watched: Int, new: Int) {
        self.watched = watched
        self.new = new
        super.init(id: id, title: title, type: type, subtype: subtype, poster: poster)
    }
    
    private enum Key: CodingKey {
        case watched, new
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.watched = try container.decode(Int.self, forKey: .watched)
        self.new = try container.decode(Int.self, forKey: .new)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(watched, forKey: .watched)
        try container.encode(new, forKey: .new)
        try super.encode(to: encoder)
    }
    
    public static func == (lhs: KPWatchingSerial, rhs: KPWatchingSerial) -> Bool {
        return lhs as KPWatchingMovie == rhs as KPWatchingMovie &&
        lhs.watched == rhs.watched && 
        lhs.new == rhs.new
    }
    
}
