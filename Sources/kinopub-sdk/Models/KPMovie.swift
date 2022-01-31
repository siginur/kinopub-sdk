//
//  KPMovie.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPMovie: KPContent {
    public let videos: [KPEpisode]
    
    required init(raw: RawData) throws {
        self.videos = try raw.parse(key: "videos", type: [RawData].self).map({ video in try KPEpisode(contentId: raw.parse(key: "id"), seasonId: nil, raw: video) })
        try super.init(raw: raw)
    }
    
    public init(id: Int, title: String, type: String, videos: [KPEpisode]) {
        self.videos = videos
        super.init(id: id, title: title, type: type)
    }
    
    private enum Key: CodingKey {
        case videos
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.videos = try container.decode([KPEpisode].self, forKey: .videos)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(videos, forKey: .videos)
        try super.encode(to: encoder)
    }
    
    public static func == (lhs: KPMovie, rhs: KPMovie) -> Bool {
        return lhs as KPContent == rhs as KPContent &&
        lhs.videos == rhs.videos
    }
}
