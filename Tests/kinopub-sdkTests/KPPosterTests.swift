//
//  KPPosterTests.swift
//  
//
//  Created by Alexey Siginur on 04/02/2022.
//

import XCTest
import kinopub_sdk

class KPPosterTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        let source = KPPoster(small: URL(string: "http://images.com/small.jpg")!, medium: URL(string: "http://images.com/medium.jpg")!, big: URL(string: "http://images.com/big.jpg")!, wide: URL(string: "http://images.com/wide.jpg")!)
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPPoster.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }
    
    func testJsonRepresentable() throws {
        guard let url = Bundle.module.url(forResource: "KPPoster-1", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        XCTAssertNoThrow(try KPPoster(json: json), "Unable to parse poster")
        
        
        guard let url = Bundle.module.url(forResource: "KPPoster-2", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        let poster = try KPPoster(json: json)
        XCTAssertTrue(poster.wide != nil, "Wrong parsing")
    }

}
