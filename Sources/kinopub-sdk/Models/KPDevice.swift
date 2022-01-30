//
//  KPDevice.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPDevice: DecodableFromRawData {
    
    public let id: Int
    public let title: String
    public let hardware: String
    public let software: String
    public let created: Date
    public let updated: Date
    public let lastSeen: Date
    public let isBrowser: Bool
    public let settings: Settings
    
    required init(raw: RawData) throws {
        self.id = try raw.parse(key: "id")
        self.title = try raw.parse(key: "title")
        self.hardware = try raw.parse(key: "hardware")
        self.software = try raw.parse(key: "software")
        self.created = try raw.parse(key: "created")
        self.updated = try raw.parse(key: "updated")
        self.lastSeen = try raw.parse(key: "last_seen")
        self.isBrowser = try raw.parse(key: "is_browser")
        self.settings = try raw.parse(key: "settings")
    }
    
    public func remove(session: KPSession? = KPSession.current, completionHandler: @escaping (KPError?) -> ()) {
        API.shared.send(accessToken: session?.accessToken, httpMethod: .post, path: "/v1/devide/\(id)/remove") { result in
            switch result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(.apiError(error))
            }
        }
    }
    
}

public extension KPDevice {
    
    class Settings: DecodableFromRawData {
        
        public let supportSSL: Bool
        public let supportHEVC: Bool
        public let supportHDR: Bool
        public let support4k: Bool
        
        required init(raw: RawData) throws {
            self.supportSSL  = try raw.parse(path: ["supportSsl", "value"]) == 1
            self.supportHEVC = try raw.parse(path: ["supportHevc", "value"]) == 1
            self.supportHDR  = try raw.parse(path: ["supportHdr", "value"]) == 1
            self.support4k   = try raw.parse(path: ["support4k", "value"]) == 1
        }
        
    }
    
}


// MARK: - Async/Await wrappers

@available(tvOS 13.0.0, watchOS 6.0, iOS 13.0.0, macOS 10.15.0, *)
public extension KPDevice {
    
    func remove(session: KPSession? = KPSession.current) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            self.remove { error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                else {
                    continuation.resume()
                }
            }
        }) as Void
    }

}
