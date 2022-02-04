//
//  KPSeasonTests.swift
//  
//
//  Created by Alexey Siginur on 04/02/2022.
//

import XCTest
import kinopub_sdk

class KPSeasonTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        let source = KPSeason(id: 3, number: 4, status: 5, episodes: [
            KPEpisode(id: 11, seasonNumber: 12, number: 13, title: "title2", duration: 14, time: 15, status: 16, updated: Date(timeIntervalSinceNow: 1)),
            KPEpisode(id: 18, seasonNumber: 19, number: 20, title: "title3", duration: 21, time: 22, status: 23, updated: Date(timeIntervalSinceNow: 2))
        ])
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPSeason.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }

}
