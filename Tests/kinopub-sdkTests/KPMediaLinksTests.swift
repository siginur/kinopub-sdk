//
//  KPMediaLinksTests.swift
//  
//
//  Created by Alexey Siginur on 31/01/2022.
//

import XCTest
import kinopub_sdk

class KPMediaLinksTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        // File
        let file1 = KPMediaLinks.File(codec: "codec", width: 2, height: 3, quality: "quality", file: "file", url: [
            "http": URL(string: "https://google.com/http")!,
            "hls": URL(string: "https://google.com/hls")!
        ])
        let file2 = KPMediaLinks.File(codec: "codec2", width: 3, height: 4, quality: "quality2", file: "file2", url: [
            "http2": URL(string: "https://google.com/http2")!,
            "hls2": URL(string: "https://google.com/hls2")!
        ])
        
        let encodedFile = try encoder.encode(file1)
        let decodedFile = try decoder.decode(KPMediaLinks.File.self, from: encodedFile)
        
        XCTAssertEqual(decodedFile, file1)
        XCTAssertTrue(decodedFile == file1)
        
        // Subtitle
        let subtitle1 = KPMediaLinks.Subtitle(lang: "lang", shift: 5, embed: true, forced: false, file: "file3", url: URL(string: "https://google.com/subtitle")!)
        let subtitle2 = KPMediaLinks.Subtitle(lang: "lang2", shift: 6, embed: false, forced: true, file: "file4", url: URL(string: "https://google.com/subtitle2")!)
        
        let encodedSubtitle = try encoder.encode(subtitle1)
        let decodedSubtitle = try decoder.decode(KPMediaLinks.Subtitle.self, from: encodedSubtitle)
        
        XCTAssertEqual(decodedSubtitle, subtitle1)
        XCTAssertTrue(decodedSubtitle == subtitle1)
        
        // KPMediaLinks
        let source = KPMediaLinks(id: 1, files: [file1, file2], subtitles: [subtitle1, subtitle2])
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPMediaLinks.self, from: encoded)
        
        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }

}
