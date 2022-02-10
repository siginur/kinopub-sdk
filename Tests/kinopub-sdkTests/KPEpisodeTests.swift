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
        let source = KPEpisode(id: 2, seasonNumber: 3, number: 4, title: "title", duration: 5, time: 6, status: 7, thumbnail: URL(string: "https://t.com/1")!, updated: Date())
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPEpisode.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }
    
    func testJsonRepresentable() throws {
        guard let url = Bundle.module.url(forResource: "KPEpisode-1", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        var episode = try KPEpisode(json: json)
        XCTAssertTrue(episode.updated != nil, "Wrong parsing")
        
        guard let url = Bundle.module.url(forResource: "KPEpisode-2", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        episode = try KPEpisode(json: json)
        XCTAssertTrue(episode.seasonNumber != nil, "Wrong parsing")
    }

}
