//
//  KPSerial.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPSerial: KPContent, CouldBeInWatchList {
    public let seasons: [Season]
    
    required init(raw: RawData) throws {
        self.seasons = try raw.parse(key: "seasons", type: [RawData].self).map({ season in try Season(serialId: raw.parse(key: "id"), raw: season) })
        try super.init(raw: raw)
    }
}

public extension KPSerial {

    class Season {
        public let serialId: Int
        public let id: Int
        public let number: Int
        public let status: Int
        public let episodes: [KPEpisode]
        
        required init(serialId: Int, raw: RawData) throws {
            self.serialId = serialId
            let id: Int = try raw.parse(key: "id")
            self.id = id
            self.number = try raw.parse(key: "number")
            self.status = try raw.parse(key: "status")
            self.episodes = try raw.parse(key: "episodes", type: [RawData].self).map({ episode in try KPEpisode(contentId: serialId, seasonId: id, raw: episode) })
        }
    }
    
}
