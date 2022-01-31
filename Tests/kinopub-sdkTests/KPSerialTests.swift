//
//  KPSerialTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPSerialTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        // Season
        let season1 = KPSerial.Season(serialId: 2, id: 3, number: 4, status: 5, episodes: [
            KPEpisode(contentId: 10, seasonId: 11, id: 12, number: 13, title: "title2", duration: 14, time: 15, status: 16, updated: Date(timeIntervalSinceNow: 1)),
            KPEpisode(contentId: 17, seasonId: 18, id: 19, number: 20, title: "title3", duration: 21, time: 22, status: 23, updated: Date(timeIntervalSinceNow: 2))
        ])
        let season2 = KPSerial.Season(serialId: 6, id: 7, number: 8, status: 9, episodes: [
            KPEpisode(contentId: 24, seasonId: 25, id: 26, number: 27, title: "title4", duration: 28, time: 29, status: 30, updated: Date(timeIntervalSinceNow: 3)),
            KPEpisode(contentId: 31, seasonId: 32, id: 33, number: 34, title: "title5", duration: 35, time: 36, status: 37, updated: Date(timeIntervalSinceNow: 4))
        ])
        
        let encodedSeason = try encoder.encode(season1)
        let decodedSeason = try decoder.decode(KPSerial.Season.self, from: encodedSeason)

        XCTAssertEqual(decodedSeason, season1)
        XCTAssertTrue(decodedSeason == season1)
        
        // Serial
        let source = KPSerial(id: 1, title: "title", type: "type", seasons: [season1, season2])
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPSerial.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }

}
