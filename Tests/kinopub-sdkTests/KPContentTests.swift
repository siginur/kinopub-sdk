//
//  KPContentTests.swift
//  
//
//  Created by Alexey Siginur on 04/02/2022.
//

import XCTest
import kinopub_sdk

class KPContentTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        let poster = KPPoster(small: URL(string: "http://images.com/small.jpg")!, medium: URL(string: "http://images.com/medium.jpg")!, big: URL(string: "http://images.com/big.jpg")!, wide: URL(string: "http://images.com/big.jpg")!)
        let source = KPContent(id: 1, title: "title", type: "type", year: 2, cast: "cast", director: "director", plot: "plot", imdb: 3, imdbRating: 4.5, imdbVotes: 6, kinopoisk: 7, kinopoiskRating: 8.9, kinopoiskVotes: 10, rating: 11, ratingVotes: 12, ratingPercentage: 13, poster: poster)
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPContent.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }

}
