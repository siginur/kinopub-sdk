//
//  KPContent.swift
//  
//
//  Created by Alexey Siginur on 04/02/2022.
//

import Foundation

public class KPContent: KPContentMetadata {
    
    public let year: Int
    public let cast: String
    public let director: String
    public let plot: String
    public let imdb: Int
    public let imdbRating: Double
    public let imdbVotes: Int
    public let kinopoisk: Int
    public let kinopoiskRating: Double
    public let kinopoiskVotes: Int
    public let rating: Int
    public let ratingVotes: Int
    public let ratingPercentage: Int
    public let poster: KPPoster
    
    public required init(json: KPJson) throws {
        self.year = try json.parse(key: "year")
        self.cast = try json.parse(key: "cast")
        self.director = try json.parse(key: "director")
        self.plot = try json.parse(key: "plot")
        self.imdb = try json.parse(key: "imdb")
        self.imdbRating = try json.parse(key: "imdb_rating")
        self.imdbVotes = try json.parse(key: "imdb_votes")
        self.kinopoisk = try json.parse(key: "kinopoisk")
        self.kinopoiskRating = try json.parse(key: "kinopoisk_rating")
        self.kinopoiskVotes = try json.parse(key: "kinopoisk_votes")
        self.rating = try json.parse(key: "rating")
        self.ratingVotes = try json.parse(key: "rating_votes")
        self.ratingPercentage = try json.parse(key: "rating_percentage")
        self.poster = try json.parse(key: "posters")
        try super.init(json: json)
    }
    
    public init(id: Int, title: String, type: String, year: Int, cast: String, director: String, plot: String, imdb: Int, imdbRating: Double, imdbVotes: Int, kinopoisk: Int, kinopoiskRating: Double, kinopoiskVotes: Int, rating: Int, ratingVotes: Int, ratingPercentage: Int, poster: KPPoster) {
        self.year = year
        self.cast = cast
        self.director = director
        self.plot = plot
        self.imdb = imdb
        self.imdbRating = imdbRating
        self.imdbVotes = imdbVotes
        self.kinopoisk = kinopoisk
        self.kinopoiskRating = kinopoiskRating
        self.kinopoiskVotes = kinopoiskVotes
        self.rating = rating
        self.ratingVotes = ratingVotes
        self.ratingPercentage = ratingPercentage
        self.poster = poster
        super.init(id: id, title: title, type: type)
    }
    
    private enum Key: CodingKey {
        case year
        case cast
        case director
        case plot
        case imdb
        case imdbRating
        case imdbVotes
        case kinopoisk
        case kinopoiskRating
        case kinopoiskVotes
        case rating
        case ratingVotes
        case ratingPercentage
        case poster
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.year = try container.decode(Int.self, forKey: .year)
        self.cast = try container.decode(String.self, forKey: .cast)
        self.director = try container.decode(String.self, forKey: .director)
        self.plot = try container.decode(String.self, forKey: .plot)
        self.imdb = try container.decode(Int.self, forKey: .imdb)
        self.imdbRating = try container.decode(Double.self, forKey: .imdbRating)
        self.imdbVotes = try container.decode(Int.self, forKey: .imdbVotes)
        self.kinopoisk = try container.decode(Int.self, forKey: .kinopoisk)
        self.kinopoiskRating = try container.decode(Double.self, forKey: .kinopoiskRating)
        self.kinopoiskVotes = try container.decode(Int.self, forKey: .kinopoiskVotes)
        self.rating = try container.decode(Int.self, forKey: .rating)
        self.ratingVotes = try container.decode(Int.self, forKey: .ratingVotes)
        self.ratingPercentage = try container.decode(Int.self, forKey: .ratingPercentage)
        self.poster = try container.decode(KPPoster.self, forKey: .poster)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(year, forKey: .year)
        try container.encode(cast, forKey: .cast)
        try container.encode(director, forKey: .director)
        try container.encode(plot, forKey: .plot)
        try container.encode(imdb, forKey: .imdb)
        try container.encode(imdbRating, forKey: .imdbRating)
        try container.encode(imdbVotes, forKey: .imdbVotes)
        try container.encode(kinopoisk, forKey: .kinopoisk)
        try container.encode(kinopoiskRating, forKey: .kinopoiskRating)
        try container.encode(kinopoiskVotes, forKey: .kinopoiskVotes)
        try container.encode(rating, forKey: .rating)
        try container.encode(ratingVotes, forKey: .ratingVotes)
        try container.encode(ratingPercentage, forKey: .ratingPercentage)
        try container.encode(poster, forKey: .poster)
        try super.encode(to: encoder)
    }
    
    public override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(year)
        hasher.combine(cast)
        hasher.combine(director)
        hasher.combine(plot)
        hasher.combine(imdb)
        hasher.combine(imdbRating)
        hasher.combine(imdbVotes)
        hasher.combine(kinopoisk)
        hasher.combine(kinopoiskRating)
        hasher.combine(kinopoiskVotes)
        hasher.combine(rating)
        hasher.combine(ratingVotes)
        hasher.combine(ratingPercentage)
        hasher.combine(poster)
    }
    
    public static func == (lhs: KPContent, rhs: KPContent) -> Bool {
        return lhs as KPContentMetadata == rhs as KPContentMetadata &&
        lhs.year == rhs.year &&
        lhs.cast == rhs.cast &&
        lhs.director == rhs.director &&
        lhs.plot == rhs.plot &&
        lhs.imdb == rhs.imdb &&
        lhs.imdbRating == rhs.imdbRating &&
        lhs.imdbVotes == rhs.imdbVotes &&
        lhs.kinopoisk == rhs.kinopoisk &&
        lhs.kinopoiskRating == rhs.kinopoiskRating &&
        lhs.kinopoiskVotes == rhs.kinopoiskVotes &&
        lhs.rating == rhs.rating &&
        lhs.ratingVotes == rhs.ratingVotes &&
        lhs.ratingPercentage == rhs.ratingPercentage &&
        lhs.poster == rhs.poster
    }
    
}
