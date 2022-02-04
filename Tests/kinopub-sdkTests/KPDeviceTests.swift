//
//  KPDeviceTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPDeviceTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        // Settings
        let settings = KPDevice.Settings(supportSSL: true, supportHEVC: false, supportHDR: true, support4k: false)
        
        let encodedSettings = try encoder.encode(settings)
        let decodedSettings = try decoder.decode(KPDevice.Settings.self, from: encodedSettings)
        
        XCTAssertEqual(decodedSettings, settings)
        XCTAssertTrue(decodedSettings == settings)
        
        // KPDevice
        let source = KPDevice(id: 1, title: "title", hardware: "hardware", software: "software", created: Date(timeIntervalSinceNow: 1), updated: Date(timeIntervalSinceNow: 2), lastSeen: Date(timeIntervalSinceNow: 3), isBrowser: true, settings: settings)
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPDevice.self, from: encoded)
        
        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }
    
    func testJsonRepresentable() throws {
        guard let url = Bundle.module.url(forResource: "KPDevice", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        
        XCTAssertNoThrow(try KPDevice(json: json), "Unable to parse device")
    }

}
