//
//  KinoPubSDKTests.swift
//
//
//  Created by Alexey Siginur on 29/01/2022.
//

import XCTest
@testable import kinopub_sdk

let accessToken = "a8vapwbh0i9h3yiu9wnaox5i5p3olf72"

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
