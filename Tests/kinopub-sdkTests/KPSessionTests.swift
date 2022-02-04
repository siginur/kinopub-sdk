//
//  KPSessionTests.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import XCTest
@testable import kinopub_sdk

class KPSessionTests: XCTestCase {

    let defaultWaitTime: TimeInterval = 5.0
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    override class func setUp() {
        KPSession(clientId: "", clientSecret: "", accessToken: accessToken).activate()
    }
    
    func testCodable() throws {
        let source = KPSession(clientId: "clientId", clientSecret: "clientSecret", accessToken: "accessToken", refreshToken: "refreshToken", expiryDate: Date())
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPSession.self, from: encoded)
        
        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }
    
    func testUserInfo() throws {
        let expectation = XCTestExpectation(description: "Get user info")
        
        KPSession.current.userInfo { result in
            do {
                let _ = try result.get()
            } catch {
                XCTFail("Unable to load user info: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
    func testGetAllDevices() throws {
        let expectation = XCTestExpectation(description: "Get all devices")
        
        KPSession.current.allDevices { result in
            do {
                let devices = try result.get()
                XCTAssertTrue(devices.count > 0, "Device list is empty")
            } catch {
                XCTFail("Unable to load all devices: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
    func testGetCurrentDevice() throws {
        let expectation = XCTestExpectation(description: "Get current device")
                
        KPSession.current.currentDevice { result in
            do {
                let _ = try result.get()
            } catch {
                XCTFail("Unable to load current device: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
    func testUpdateCurrentDeivce() throws {
        let expectation = XCTestExpectation(description: "Update current device")

        let title = "Title test \(Int.random(in: 1..<1000000000))"
        let hardware = "Hardware test \(Int.random(in: 1..<1000000000))"
        let software = "Software test \(Int.random(in: 1..<1000000000))"
        
        KPSession.current.updateCurrentDevice(title: title, hardware: hardware, software: software) { error in
            guard error == nil else {
                XCTFail("Failed to update current device: \(error!)")
                expectation.fulfill()
                return
            }
            
            KPSession.current.currentDevice { result in
                do {
                    let device = try result.get()
                    XCTAssertEqual(device.title, title)
                    XCTAssertEqual(device.hardware, hardware)
                    XCTAssertEqual(device.software, software)
                } catch {
                    XCTFail("Unable to check device info after update: \(error)")
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: defaultWaitTime * 2)
    }
    
    func testGetWatchlist() throws {
        let expectation = XCTestExpectation(description: "Get watching serials")
        
        KPSession.current.getWatchlist { result in
            do {
                let serials = try result.get()
                XCTAssertTrue(serials.count > 0, "Watching serials list is empty")
            } catch {
                XCTFail("Unable to get watching serials: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
    func testGetContentMetadata() throws {
        let expectationSerial = XCTestExpectation(description: "Get serial content metadata")
        KPSession.current.getContentMetadata(byId: 15396) { result in
            do {
                let content = try result.get()
                guard let serial = content as? KPSerialMetadata else {
                    XCTFail("Unable to convert content to serial metadata")
                    return
                }
                XCTAssertTrue(serial.seasons.count > 0, "No seasons in serial content metadata")
                for season in serial.seasons {
                    XCTAssertTrue(season.episodes.count > 0, "No episodes in serial season content metadata")
                }
            } catch {
                XCTFail("Unable to get serial content metadata: \(error)")
            }
            expectationSerial.fulfill()
        }
        
        let expectationMovie = XCTestExpectation(description: "Get movie content metadata")
        KPSession.current.getContentMetadata(byId: 76429) { result in
            do {
                let content = try result.get()
                guard let movie = content as? KPMovieMetadata else {
                    XCTFail("Unable to convert content to movie metadata")
                    return
                }
                XCTAssertTrue(movie.videos.count > 0, "No videos in movie content metadata")
            } catch {
                XCTFail("Unable to get movie content metadata: \(error)")
            }
            expectationMovie.fulfill()
        }
        
        wait(for: [expectationSerial, expectationMovie], timeout: defaultWaitTime * 2)
    }
    
    func testGetSerialMetadata() throws {
        let expectation = XCTestExpectation(description: "Get serial metadata")
        KPSession.current.getSerialMetadata(byId: 15396) { result in
            do {
                let serial = try result.get()
                XCTAssertTrue(serial.seasons.count > 0, "No seasons in serial metadata")
                for season in serial.seasons {
                    XCTAssertTrue(season.episodes.count > 0, "No episodes in serial metadata season")
                }
            } catch {
                XCTFail("Unable to get serial metadata: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
    func testGetMovieMetadata() throws {
        let expectation = XCTestExpectation(description: "Get movie metadata")
        
        KPSession.current.getMovieMetadata(byId: 76429) { result in
            do {
                let movie = try result.get()
                XCTAssertTrue(movie.videos.count > 0, "No videos in movie metadata")
            } catch {
                XCTFail("Unable to get movie metadata: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
    func testGetContent() throws {
        let expectationSerial = XCTestExpectation(description: "Get serial content")
        KPSession.current.getContent(byId: 15396) { result in
            do {
                let content = try result.get()
                guard let serial = content as? KPSerial else {
                    XCTFail("Unable to convert content to serial")
                    return
                }
                XCTAssertTrue(serial.seasons.count > 0, "No seasons in serial content")
                for season in serial.seasons {
                    XCTAssertTrue(season.episodes.count > 0, "No episodes in serial season content")
                }
            } catch {
                XCTFail("Unable to get serial content: \(error)")
            }
            expectationSerial.fulfill()
        }
        
        let expectationMovie = XCTestExpectation(description: "Get movie content")
        KPSession.current.getContent(byId: 76429) { result in
            do {
                let content = try result.get()
                guard let movie = content as? KPMovie else {
                    XCTFail("Unable to convert content to movie")
                    return
                }
                XCTAssertTrue(movie.videos.count > 0, "No videos in movie content")
            } catch {
                XCTFail("Unable to get movie content: \(error)")
            }
            expectationMovie.fulfill()
        }
        
        wait(for: [expectationSerial, expectationMovie], timeout: defaultWaitTime * 2)
    }
    
    func testGetSerial() throws {
        let expectation = XCTestExpectation(description: "Get serial")
        KPSession.current.getSerial(byId: 15396) { result in
            do {
                let serial = try result.get()
                XCTAssertTrue(serial.seasons.count > 0, "No seasons in serial")
                for season in serial.seasons {
                    XCTAssertTrue(season.episodes.count > 0, "No episodes in serial season")
                }
            } catch {
                XCTFail("Unable to get serial: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
    func testGetMovie() throws {
        let expectation = XCTestExpectation(description: "Get movie")
        
        KPSession.current.getMovie(byId: 76429) { result in
            do {
                let movie = try result.get()
                XCTAssertTrue(movie.videos.count > 0, "No videos in movie")
            } catch {
                XCTFail("Unable to get movie: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
    func testGetMediaLinks() throws {
        let expectation = XCTestExpectation(description: "Get media links")
        
        KPSession.current.getMediaLinks(byId: 162259) { result in
            do {
                let mediaLinks = try result.get()
                XCTAssertTrue(mediaLinks.files.count > 0, "No files in media links")
                XCTAssertTrue(mediaLinks.subtitles.count > 0, "No subtitles in media links")
            } catch {
                XCTFail("Unable to get media links: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
    func testGetVideoLink() throws {
        let expectation = XCTestExpectation(description: "Get video link")
        
        KPSession.current.getVideoLink(byFilename: "/2/d6/10lg5gbxyb58jeWTK.mp4", type: "http") { result in
            do {
                let _ = try result.get()
            } catch {
                XCTFail("Unable to get video link: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }

}
