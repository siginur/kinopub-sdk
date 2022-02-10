//
//  KPSerialTests.swift
//  
//
//  Created by Alexey Siginur on 04/02/2022.
//

import XCTest
import kinopub_sdk

class KPSerialTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testCodable() throws {
        let season1 = KPSeason(id: 3, number: 4, status: 5, episodes: [
            KPEpisode(id: 11, seasonNumber: 12, number: 13, title: "title2", duration: 14, time: 15, status: 16, thumbnail: URL(string: "https://t.com/1")!, updated: Date(timeIntervalSinceNow: 1)),
            KPEpisode(id: 18, seasonNumber: 19, number: 20, title: "title3", duration: 21, time: 22, status: 23, thumbnail: URL(string: "https://t.com/2")!, updated: Date(timeIntervalSinceNow: 2))
        ])
        let season2 = KPSeason(id: 7, number: 8, status: 9, episodes: [
            KPEpisode(id: 25, seasonNumber: 26, number: 27, title: "title4", duration: 28, time: 29, status: 30, thumbnail: URL(string: "https://t.com/3")!, updated: Date(timeIntervalSinceNow: 3)),
            KPEpisode(id: 32, seasonNumber: 33, number: 34, title: "title5", duration: 35, time: 36, status: 37, thumbnail: URL(string: "https://t.com/4")!, updated: Date(timeIntervalSinceNow: 4))
        ])
        let poster = KPPoster(small: URL(string: "http://url.com/1")!, medium: URL(string: "http://url.com/2")!, big: URL(string: "http://url.com/3")!, wide: URL(string: "http://url.com/4")!)
        
        let source = KPSerial(id: 1, title: "title", type: "type", year: 2, cast: "cast", director: "director", plot: "plot", imdb: 3, imdbRating: 4.5, imdbVotes: 6, kinopoisk: 7, kinopoiskRating: 8.9, kinopoiskVotes: 10, rating: 11, ratingVotes: 12, ratingPercentage: 13, poster: poster, seasons: [season1, season2])
        
        let encoded = try encoder.encode(source)
        let decoded = try decoder.decode(KPSerial.self, from: encoded)

        XCTAssertEqual(decoded, source)
        XCTAssertTrue(decoded == source)
    }
    
    func testJsonRepresentable() throws {
        guard let url = Bundle.module.url(forResource: "KPSerial", withExtension: "json", subdirectory: "json"),
              let json = try JSONSerialization.jsonObject(with: Data(contentsOf: url), options: []) as? KPJson
        else {
            XCTFail("Wrong resource")
            return
        }
        
        XCTAssertNoThrow(try KPSerial(json: json), "Unable to parse serial")
    }

}
