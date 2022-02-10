//
//  KPMovie.swift
//  
//
//  Created by Alexey Siginur on 04/02/2022.
//

import Foundation

public class KPMovie: KPContent {
    public let videos: [KPEpisode]
    
    public required init(json: KPJson) throws {
        self.videos = try json.parse(key: "videos", type: [KPJson].self).map(KPEpisode.init(json:))
        try super.init(json: json)
    }
    
    public init(id: Int, title: String, type: String, year: Int, cast: String, director: String, plot: String, imdb: Int, imdbRating: Double, imdbVotes: Int, kinopoisk: Int, kinopoiskRating: Double, kinopoiskVotes: Int, rating: Int, ratingVotes: Int, ratingPercentage: Int, poster: KPPoster, videos: [KPEpisode]) {
        self.videos = videos
        super.init(id: id, title: title, type: type, year: year, cast: cast, director: director, plot: plot, imdb: imdb, imdbRating: imdbRating, imdbVotes: imdbVotes, kinopoisk: kinopoisk, kinopoiskRating: kinopoiskRating, kinopoiskVotes: kinopoiskVotes, rating: rating, ratingVotes: ratingVotes, ratingPercentage: ratingPercentage, poster: poster)
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
    
    public override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(videos)
    }
    
    public static func == (lhs: KPMovie, rhs: KPMovie) -> Bool {
        return lhs as KPContent == rhs as KPContent &&
        lhs.videos == rhs.videos
    }
    
}
