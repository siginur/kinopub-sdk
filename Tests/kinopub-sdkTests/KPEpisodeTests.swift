//
//  KPEpisodeTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPEpisodeTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        let source = KPEpisode(contentId: 1, seasonId: 2, id: 3, number: 4, title: "title", duration: 5, time: 6, status: 7, updated: Date())
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPEpisode.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }

}
