//
//  KPMetadataTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPMetadataTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        let source = KPContentMetadata(id: 1, title: "title", type: "type")
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPContentMetadata.self, from: encoded)
        
        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }

}
