//
//  KinoPubSDKTests.swift
//
//
//  Created by Alexey Siginur on 29/01/2022.
//

import XCTest
@testable import kinopub_sdk

let accessToken = "jqn5andu1g7zx19ezwxcyk0kxo0xrwgs"

final class KinoPubSDKTests: XCTestCase {
    
    let defaultWaitTime: TimeInterval = 5.0
    
    override class func setUp() {
        KPSession(clientId: "", clientSecret: "", accessToken: accessToken).activate()
    }
    
    func test() throws {
        let expectation = XCTestExpectation(description: "")
        expectation.fulfill()
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
}
