//
//  KPMovieTests.swift
//  
//
//  Created by Alexey Siginur on 05/02/2022.
//

import XCTest
import kinopub_sdk

class KPMovieTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        let poster = KPPoster(small: URL(string: "http://url.com/1")!, medium: URL(string: "http://url.com/2")!, big: URL(string: "http://url.com/3")!, wide: URL(string: "http://url.com/4")!)
        let source = KPMovie(id: 1, title: "title", type: "type", year: 2, cast: "cast", director: "director", plot: "plot", imdb: 3, imdbRating: 4.5, imdbVotes: 6, kinopoisk: 7, kinopoiskRating: 8.9, kinopoiskVotes: 10, rating: 11, ratingVotes: 12, ratingPercentage: 13, poster: poster, videos: [
            KPEpisode(id: 4, seasonNumber: 3, number: 5, title: "title2", duration: 6, time: 7, status: 8, updated: Date(timeIntervalSinceNow: 1)),
            KPEpisode(id: 11, seasonNumber: 10, number: 12, title: "title3", duration: 13, time: 14, status: 15, updated: Date(timeIntervalSinceNow: 2))
        ])
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPMovie.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }
    
    func testJsonRepresentable() throws {
        guard let url = Bundle.module.url(forResource: "KPMovie", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        
        XCTAssertNoThrow(try KPMovie(json: json), "Unable to parse movie")
    }

}
