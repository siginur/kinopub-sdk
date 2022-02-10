//
//  KPSerialMetadata.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPSerialMetadata: KPContentMetadata, CouldBeInWatchList {
    public let seasons: [KPSeason]
    
    public required init(json: KPJson) throws {
        self.seasons = try json.parse(key: "seasons", type: [KPJson].self).map(KPSeason.init(json:))
        try super.init(json: json)
    }
    
    public init(id: Int, title: String, type: String, seasons: [KPSeason]) {
        self.seasons = seasons
        super.init(id: id, title: title, type: type)
    }
    
    private enum Key: CodingKey {
        case seasons
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.seasons = try container.decode([KPSeason].self, forKey: .seasons)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(seasons, forKey: .seasons)
        try super.encode(to: encoder)
    }
    
    public override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(seasons)
    }
    
    public static func == (lhs: KPSerialMetadata, rhs: KPSerialMetadata) -> Bool {
        return lhs as KPContentMetadata == rhs as KPContentMetadata &&
        lhs.seasons == rhs.seasons
    }
}
