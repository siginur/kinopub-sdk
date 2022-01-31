//
//  KPWatchingMovieTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPWatchingMovieTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        // Poster
        let poster = KPWatchingMovie.Poster(small: URL(string: "http://images.com/small.jpg")!, medium: URL(string: "http://images.com/medium.jpg")!, big: URL(string: "http://images.com/big.jpg")!)
        let encodedPoster = try encoder.encode(poster)
        let decodedPoster = try decoder.decode(KPWatchingMovie.Poster.self, from: encodedPoster)

        XCTAssertEqual(decodedPoster, poster)
        XCTAssertTrue(decodedPoster == poster)
        
        // Movie
        let source = KPWatchingMovie(id: 1, title: "title", type: "type", subtype: "subtype", poster: poster)
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPWatchingMovie.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }

}
