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
}
