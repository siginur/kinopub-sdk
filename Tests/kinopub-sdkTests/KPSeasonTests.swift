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
            KPEpisode(id: 11, seasonNumber: 12, number: 13, title: "title2", duration: 14, time: 15, status: 16, thumbnail: URL(string: "https://t.com/1")!, updated: Date(timeIntervalSinceNow: 1)),
            KPEpisode(id: 18, seasonNumber: 19, number: 20, title: "title3", duration: 21, time: 22, status: 23, thumbnail: URL(string: "https://t.com/2")!, updated: Date(timeIntervalSinceNow: 2))
        ])
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPSeason.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }
    
    func testJsonRepresentable() throws {
        guard let url = Bundle.module.url(forResource: "KPSeason-1", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        XCTAssertNoThrow(try KPSeason(json: json), "Unable to parse season")
        
        guard let url = Bundle.module.url(forResource: "KPSeason-2", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        XCTAssertNoThrow(try KPSeason(json: json), "Unable to parse season")
    }

}
