//
//  KPMovieMetadataTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPMovieMetadataTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        let source = KPMovieMetadata(id: 1, title: "title", type: "type", videos: [
            KPEpisode(id: 4, seasonNumber: 3, number: 5, title: "title2", duration: 6, time: 7, status: 8, updated: Date(timeIntervalSinceNow: 1)),
            KPEpisode(id: 11, seasonNumber: 10, number: 12, title: "title3", duration: 13, time: 14, status: 15, updated: Date(timeIntervalSinceNow: 2))
        ])
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPMovieMetadata.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }

}
