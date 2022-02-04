//
//  KPUserTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPUserTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func testCodable() throws {
        let source = KPUser(username: "username", name: "name", avatar: URL(string: "https://google.com")!, registrationDate: Date(timeIntervalSinceNow: 1), subscriptionExpiryDate: Date(timeIntervalSinceNow: 2))
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPUser.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }
    
    func testJsonRepresentable() throws {
        guard let url = Bundle.module.url(forResource: "KPUser", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        
        XCTAssertNoThrow(try KPUser(json: json), "Unable to parse user info")
    }

}
