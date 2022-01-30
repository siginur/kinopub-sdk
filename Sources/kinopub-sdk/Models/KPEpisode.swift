//
//  KPEpisode.swift
//  
//
//  Created by Alexey Siginur on 30/01/2022.
//

import Foundation

public class KPEpisode {
    public let contentId: Int
    public let seasonId: Int?
    public let id: Int
    public let number: Int
    public let title: String
    public let duration: TimeInterval
    public let time: TimeInterval
    public let status: Int
    public let updated: Date?
    
    required init(contentId: Int, seasonId: Int?, raw: RawData) throws {
        self.contentId = contentId
        self.seasonId = seasonId
        self.id = try raw.parse(key: "id")
        self.number = try raw.parse(key: "number")
        self.title = try raw.parse(key: "title")
        self.duration = try raw.parse(key: "duration")
        self.time = try raw.parse(key: "time")
        self.status = try raw.parse(key: "status")
        self.updated = try? raw.parse(key: "updated")
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
