//
//  KPSerial.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPSerial: KPContent, CouldBeInWatchList {
    public let seasons: [Season]
    
    public required init(json: KPJson) throws {
        self.seasons = try json.parse(key: "seasons", type: [KPJson].self).map({ season in try Season(serialId: json.parse(key: "id"), raw: season) })
        try super.init(json: json)
    }
    
    public init(id: Int, title: String, type: String, seasons: [Season]) {
        self.seasons = seasons
        super.init(id: id, title: title, type: type)
    }
    
    private enum Key: CodingKey {
        case seasons
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.seasons = try container.decode([Season].self, forKey: .seasons)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(seasons, forKey: .seasons)
        try super.encode(to: encoder)
    }
    
    public static func == (lhs: KPSerial, rhs: KPSerial) -> Bool {
        return lhs as KPContent == rhs as KPContent &&
        lhs.seasons == rhs.seasons
    }
}

public extension KPSerial {

    class Season: Codable, Equatable {
        public let serialId: Int
        public let id: Int
        public let number: Int
        public let status: Int
        public let episodes: [KPEpisode]
        
        public required init(serialId: Int, raw: KPJson) throws {
            self.serialId = serialId
            let id: Int = try raw.parse(key: "id")
            self.id = id
            self.number = try raw.parse(key: "number")
            self.status = try raw.parse(key: "status")
            self.episodes = try raw.parse(key: "episodes", type: [KPJson].self).map({ episode in try KPEpisode(contentId: serialId, seasonId: id, raw: episode) })
        }
        
        public init(serialId: Int, id: Int, number: Int, status: Int, episodes: [KPEpisode]) {
            self.serialId = serialId
            self.id = id
            self.number = number
            self.status = status
            self.episodes = episodes
        }
        
        public static func == (lhs: KPSerial.Season, rhs: KPSerial.Season) -> Bool {
            return lhs.serialId == rhs.serialId &&
            lhs.id == rhs.id &&
            lhs.number == rhs.number &&
            lhs.status == rhs.status &&
            lhs.episodes == rhs.episodes
        }
    }
    
}
