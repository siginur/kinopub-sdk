//
//  KPSerial.swift
//  
//
//  Created by Alexey Siginur on 02/02/2022.
//

import Foundation

public class KPSerial: KPContent {
    public let seasons: [KPSeason]
    
    public required init(json: KPJson) throws {
        self.seasons = try json.parse(key: "seasons", type: [KPJson].self).map(KPSeason.init(json:))
        try super.init(json: json)
    }
    
    public init(id: Int, title: String, type: String, year: Int, cast: String, director: String, plot: String, imdb: Int, imdbRating: Double, imdbVotes: Int, kinopoisk: Int, kinopoiskRating: Double, kinopoiskVotes: Int, rating: Int, ratingVotes: Int, ratingPercentage: Int, poster: KPPoster, seasons: [KPSeason]) {
        self.seasons = seasons
        super.init(id: id, title: title, type: type, year: year, cast: cast, director: director, plot: plot, imdb: imdb, imdbRating: imdbRating, imdbVotes: imdbVotes, kinopoisk: kinopoisk, kinopoiskRating: kinopoiskRating, kinopoiskVotes: kinopoiskVotes, rating: rating, ratingVotes: ratingVotes, ratingPercentage: ratingPercentage, poster: poster)
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
    
    public static func == (lhs: KPSerial, rhs: KPSerial) -> Bool {
        return lhs as KPContent == rhs as KPContent &&
        lhs.seasons == rhs.seasons
    }
    
}
