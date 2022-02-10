//
//  KPSeason.swift
//  
//
//  Created by Alexey Siginur on 04/02/2022.
//

import Foundation

public class KPSeason: Codable, Hashable, Identifiable, KPJsonRepresentable {
    
    public let id: Int
    public let number: Int
    public let status: Int
    public let episodes: [KPEpisode]
    
    public required init(json: KPJson) throws {
        let id: Int = try json.parse(key: "id")
        self.id = id
        self.number = try json.parse(key: "number")
        do {
            // For request: GET /v1/watching?id=12076
            self.status = try json.parse(key: "status")
        } catch {
            // For request: GET /v1/items/12076
            self.status = try json.parse(path: ["watching", "status"])
        }
        self.episodes = try json.parse(key: "episodes", type: [KPJson].self).map(KPEpisode.init(json:))
    }
    
    public init(id: Int, number: Int, status: Int, episodes: [KPEpisode]) {
        self.id = id
        self.number = number
        self.status = status
        self.episodes = episodes
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(number)
        hasher.combine(status)
        hasher.combine(episodes)
    }
    
    public static func == (lhs: KPSeason, rhs: KPSeason) -> Bool {
        return lhs.id == rhs.id &&
        lhs.number == rhs.number &&
        lhs.status == rhs.status &&
        lhs.episodes == rhs.episodes
    }
    
}
