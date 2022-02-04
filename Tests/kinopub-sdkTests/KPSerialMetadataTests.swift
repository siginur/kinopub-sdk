//
//  KPSerialMetadataTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPSerialMetadataTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        let season1 = KPSeason(id: 3, number: 4, status: 5, episodes: [
            KPEpisode(id: 11, seasonNumber: 12, number: 13, title: "title2", duration: 14, time: 15, status: 16, updated: Date(timeIntervalSinceNow: 1)),
            KPEpisode(id: 18, seasonNumber: 19, number: 20, title: "title3", duration: 21, time: 22, status: 23, updated: Date(timeIntervalSinceNow: 2))
        ])
        let season2 = KPSeason(id: 7, number: 8, status: 9, episodes: [
            KPEpisode(id: 25, seasonNumber: 26, number: 27, title: "title4", duration: 28, time: 29, status: 30, updated: Date(timeIntervalSinceNow: 3)),
            KPEpisode(id: 32, seasonNumber: 33, number: 34, title: "title5", duration: 35, time: 36, status: 37, updated: Date(timeIntervalSinceNow: 4))
        ])
        let source = KPSerialMetadata(id: 1, title: "title", type: "type", seasons: [season1, season2])
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPSerialMetadata.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }

}
