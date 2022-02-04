//
//  KPWatchingSerialTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPWatchingSerialTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        let poster = KPPoster(small: URL(string: "http://images.com/small.jpg")!, medium: URL(string: "http://images.com/medium.jpg")!, big: URL(string: "http://images.com/big.jpg")!, wide: URL(string: "http://images.com/wide.jpg")!)
        let source = KPWatchingSerial(id: 1, title: "title", type: "type", subtype: "subtype", poster: poster, watched: 2, new: 3)
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPWatchingSerial.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }
    
    func testJsonRepresentable() throws {
        guard let url = Bundle.module.url(forResource: "KPWatchingSerial", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        
        XCTAssertNoThrow(try KPWatchingSerial(json: json), "Unable to parse watching serial")
    }

}
