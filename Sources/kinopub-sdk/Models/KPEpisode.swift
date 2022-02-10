//
//  KPEpisode.swift
//  
//
//  Created by Alexey Siginur on 30/01/2022.
//

import Foundation

public class KPEpisode: Codable, Hashable, Identifiable, KPJsonRepresentable {
    
    public let id: Int
    public let seasonNumber: Int?
    public let number: Int
    public let title: String
    public let duration: TimeInterval
    public let time: TimeInterval
    public let status: Int
    public let thumbnail: URL?
    public let updated: Date?
    
    public required init(json: KPJson) throws {
        self.id = try json.parse(key: "id")
        self.seasonNumber = try? json.parse(key: "snumber")
        self.number = try json.parse(key: "number")
        self.title = try json.parse(key: "title")
        self.duration = try json.parse(key: "duration")
        var thumbnail: URL?
        var updated: Date?
        let watching: KPJson
        do {
            // For request: GET /v1/items/12076
            thumbnail = try json.parse(key: "thumbnail")
            updated = nil
            watching = try json.parse(key: "watching", type: KPJson.self)
        } catch {
            // For request: GET /v1/watching?id=12076
            thumbnail = nil
            updated = try? json.parse(key: "updated")
            watching = json
        }
        self.time = try watching.parse(key: "time")
        self.status = try watching.parse(key: "status")
        self.thumbnail = thumbnail
        self.updated = updated
    }
    
    public init(id: Int, seasonNumber: Int?, number: Int, title: String, duration: TimeInterval, time: TimeInterval, status: Int, thumbnail: URL?, updated: Date?) {
        self.id = id
        self.seasonNumber = seasonNumber
        self.number = number
        self.title = title
        self.duration = duration
        self.time = time
        self.status = status
        self.thumbnail = thumbnail
        self.updated = updated
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(seasonNumber)
        hasher.combine(number)
        hasher.combine(title)
        hasher.combine(duration)
        hasher.combine(time)
        hasher.combine(status)
        hasher.combine(thumbnail)
        hasher.combine(updated)
    }
    
    public func getMediaLinks(session: KPSession? = KPSession.current, completionHandler: @escaping (Result<KPMediaLinks, KPError>) -> ()) {
        guard let session = session else {
            DispatchQueue.global().async {
                completionHandler(.failure(.noActiveSession))
            }
            return
        }
        session.getMediaLinks(byId: self.id, completionHandler: completionHandler)
    }
    
    public static func == (lhs: KPEpisode, rhs: KPEpisode) -> Bool {
        return lhs.id == rhs.id &&
        lhs.seasonNumber == rhs.seasonNumber &&
        lhs.number == rhs.number &&
        lhs.title == rhs.title &&
        lhs.duration == rhs.duration &&
        lhs.time == rhs.time &&
        lhs.status == rhs.status &&
        lhs.thumbnail == rhs.thumbnail &&
        lhs.updated == rhs.updated
    }

}


// MARK: - Async/Await wrappers

@available(tvOS 13.0.0, watchOS 6.0, iOS 13.0.0, macOS 10.15.0, *)
public extension KPEpisode {
    
    func getMediaLinks(session: KPSession? = KPSession.current) async throws -> KPMediaLinks {
        try await withCheckedThrowingContinuation({ continuation in
            getMediaLinks(session: session, completionHandler: continuation.resume(with:))
        })
    }
    
}
