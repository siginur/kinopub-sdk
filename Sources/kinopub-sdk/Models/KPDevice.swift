//
//  KPDevice.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPDevice: Codable, Equatable, KPJsonRepresentable {
    
    public let id: Int
    public let title: String
    public let hardware: String
    public let software: String
    public let created: Date
    public let updated: Date
    public let lastSeen: Date
    public let isBrowser: Bool
    public let settings: Settings
    
    public required init(json: KPJson) throws {
        self.id = try json.parse(key: "id")
        self.title = try json.parse(key: "title")
        self.hardware = try json.parse(key: "hardware")
        self.software = try json.parse(key: "software")
        self.created = try json.parse(key: "created")
        self.updated = try json.parse(key: "updated")
        self.lastSeen = try json.parse(key: "last_seen")
        self.isBrowser = try json.parse(key: "is_browser")
        self.settings = try json.parse(key: "settings")
    }
    
    public init(id: Int, title: String, hardware: String, software: String, created: Date, updated: Date, lastSeen: Date, isBrowser: Bool, settings: KPDevice.Settings) {
        self.id = id
        self.title = title
        self.hardware = hardware
        self.software = software
        self.created = created
        self.updated = updated
        self.lastSeen = lastSeen
        self.isBrowser = isBrowser
        self.settings = settings
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
    
    public static func == (lhs: KPDevice, rhs: KPDevice) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.hardware == rhs.hardware &&
        lhs.software == rhs.software &&
        lhs.created == rhs.created &&
        lhs.updated == rhs.updated &&
        lhs.lastSeen == rhs.lastSeen &&
        lhs.isBrowser == rhs.isBrowser &&
        lhs.settings == rhs.settings
    }
    
}

public extension KPDevice {
    
    class Settings: Codable, Equatable, KPJsonRepresentable {
        
        public let supportSSL: Bool
        public let supportHEVC: Bool
        public let supportHDR: Bool
        public let support4k: Bool
        
        public required init(json: KPJson) throws {
            self.supportSSL  = try json.parse(path: ["supportSsl", "value"]) == 1
            self.supportHEVC = try json.parse(path: ["supportHevc", "value"]) == 1
            self.supportHDR  = try json.parse(path: ["supportHdr", "value"]) == 1
            self.support4k   = try json.parse(path: ["support4k", "value"]) == 1
        }
        
        public init(supportSSL: Bool, supportHEVC: Bool, supportHDR: Bool, support4k: Bool) {
            self.supportSSL = supportSSL
            self.supportHEVC = supportHEVC
            self.supportHDR = supportHDR
            self.support4k = support4k
        }
        
        public static func == (lhs: KPDevice.Settings, rhs: KPDevice.Settings) -> Bool {
            return lhs.supportSSL == rhs.supportSSL &&
            lhs.supportHEVC == rhs.supportHEVC &&
            lhs.supportHDR == rhs.supportHDR &&
            lhs.support4k == rhs.support4k
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
