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
        let poster = KPPoster(small: URL(string: "http://images.com/small.jpg")!, medium: URL(string: "http://images.com/medium.jpg")!, big: URL(string: "http://images.com/big.jpg")!, wide: URL(string: "http://images.com/wide.jpg")!)
        let source = KPWatchingMovie(id: 1, title: "title", type: "type", subtype: "subtype", poster: poster)
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPWatchingMovie.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }

}
