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

}
