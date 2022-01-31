//
//  KPMovieTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPMovieTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        let source = KPMovie(id: 1, title: "title", type: "type", videos: [
            KPEpisode(contentId: 2, seasonId: 3, id: 4, number: 5, title: "title2", duration: 6, time: 7, status: 8, updated: Date(timeIntervalSinceNow: 1)),
            KPEpisode(contentId: 9, seasonId: 10, id: 11, number: 12, title: "title3", duration: 13, time: 14, status: 15, updated: Date(timeIntervalSinceNow: 2))
        ])
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPMovie.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }

}
