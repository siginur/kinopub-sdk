//
//  KPMovieMetadata.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPMovieMetadata: KPContentMetadata {
    public let videos: [KPEpisode]
    
    public required init(json: KPJson) throws {
        self.videos = try json.parse(key: "videos", type: [KPJson].self).map(KPEpisode.init(json:))
        try super.init(json: json)
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
    
    public static func == (lhs: KPMovieMetadata, rhs: KPMovieMetadata) -> Bool {
        return lhs as KPContentMetadata == rhs as KPContentMetadata &&
        lhs.videos == rhs.videos
    }
}
