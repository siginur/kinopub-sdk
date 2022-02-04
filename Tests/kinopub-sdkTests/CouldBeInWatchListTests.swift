//
//  CouldBeInWatchListTests.swift
//  
//
//  Created by Alexey Siginur on 30/01/2022.
//

import XCTest
@testable import kinopub_sdk

final class CouldBeInWatchListTests: XCTestCase {
    
    let defaultWaitTime: TimeInterval = 10.0
    
    override class func setUp() {
        KPSession(clientId: "", clientSecret: "", accessToken: accessToken).activate()
    }
    
    func testToggleWatchList() throws {
        let expectation = XCTestExpectation(description: "Toggle serial in watchlist")
        
        KPSession.current.getSerialMetadata(byId: 15109) { result in
            do {
                let serial = try result.get()
                serial.toggleWatchList(completionHandler: { result in
                    do {
                        let current = try result.get()
                        serial.toggleWatchList(completionHandler: { result in
                            do {
                                let updated = try result.get()
                                XCTAssertNotEqual(current, updated)
                                expectation.fulfill()
                            } catch {
                                XCTFail("Unable to toggle serial in watchlist")
                            }
                        })
                    } catch {
                        XCTFail("Unable to toggle serial in watchlist")
                    }
                })
            } catch {
                XCTFail("Unable to get serial")
            }
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
}
