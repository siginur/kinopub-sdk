//
//  KPBookmarkFolderTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPBookmarkFolderTests: XCTestCase {
    
    let defaultWaitTime: TimeInterval = 10.0
    let defaultFolderId: Int = 1868287
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    override class func setUp() {
        KPSession(clientId: "", clientSecret: "", accessToken: accessToken).activate()
    }
    
    func testCodable() throws {
        let source = KPBookmarkFolder(id: 123, title: "Some title", views: 456, count: 789, created: .init(), updated: .init(timeIntervalSinceReferenceDate: 654))
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPBookmarkFolder.self, from: encoded)
        
        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }
    
    func testJsonRepresentable() throws {
        guard let url = Bundle.module.url(forResource: "KPBookmarkFolder", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        
        XCTAssertNoThrow(try KPBookmarkFolder(json: json), "Unable to parse bookmark folder info")
    }
    
    func testGetBookmarkFolders() throws {
        let expectation = XCTestExpectation(description: "Get bookmark folders")
        
        KPSession.current.getBookmarkFolders { result in
            do {
                let folders = try result.get()
                XCTAssertGreaterThan(folders.count, 0)
                XCTAssertNotNil(folders.first(where: { $0.title == "Watch it later" }))
                expectation.fulfill()
            } catch {
                XCTFail("Unable to get bookmark folder")
            }
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
    func testGetBookmarkFolderItems() throws {
        let expectation = XCTestExpectation(description: "Get bookmark folder items")
        
        KPSession.current.getBookmarkFolderItems(folderId: defaultFolderId) { result in
            do {
                let items = try result.get().items
                XCTAssertGreaterThan(items.count, 0)
                expectation.fulfill()
            } catch {
                print(error)
                XCTFail("Unable to get bookmark folder items")
            }
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
    func testAddRemoveBookmarks() throws {
        let expectation = XCTestExpectation(description: "Add/Remove bookmarks")
        
        // Add to bookmarks
        KPSession.current.addToBookmarks(itemId: 94663, folderId: self.defaultFolderId) { error in
            if let error {
                XCTFail(error.localizedDescription)
                return
            }
            
            // Check that it was added
            KPSession.current.getBookmarkFolderItems(folderId: self.defaultFolderId) { result in
                do {
                    let items = try result.get().items
                    XCTAssertTrue(items.contains(where: { $0.id == 94663 }))
                    
                    // Remove from bookmarks
                    KPSession.current.removeFromBookmarks(itemId: 94663, folderId: self.defaultFolderId) { error in
                        if let error {
                            XCTFail(error.localizedDescription)
                            return
                        }
                        
                        // Check that it was removed
                        KPSession.current.getBookmarkFolderItems(folderId: self.defaultFolderId) { result in
                            do {
                                let items = try result.get().items
                                XCTAssertFalse(items.contains(where: { $0.id == 94663 }))
                                
                                expectation.fulfill()
                            } catch {
                                XCTFail(error.localizedDescription)
                            }
                        }
                    }
                } catch {
                    XCTFail(error.localizedDescription)
                }
            }
        }
        
        wait(for: [expectation], timeout: defaultWaitTime)
    }
    
}
