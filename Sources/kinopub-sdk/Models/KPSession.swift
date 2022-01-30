//
//  KPSession.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPSession {
    
    public private(set) static var current: KPSession! = nil
    
    public let clientId: String
    public let clientSecret: String
    public private(set) var accessToken: String
    public private(set) var refreshToken: String?
    public private(set) var expiryDate: Date?
    
    public init(clientId: String, clientSecret: String, accessToken: String, refreshToken: String? = nil, expiryDate: Date? = nil) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiryDate = expiryDate
    }
    
    init(authInfo: AuthenticationUserInfo) {
        self.clientId = Storage.Auth.clientId
        self.clientSecret = Storage.Auth.clientSecret
        self.accessToken = authInfo.accessToken
        self.refreshToken = authInfo.refreshToken
        self.expiryDate = Date(timeIntervalSinceNow: authInfo.expiresIn - 2 * 60)
    }
    
    public func activate() {
        Self.current = self
    }
    
    public func refresh(completionHandler: ((Error?) -> ())? = nil) {
        guard let refreshToken = self.refreshToken else {
            DispatchQueue.global().async {
                completionHandler?(KPError.noRefreshToken)
            }
            return
        }

        API.shared.refreshAccessToken(clientId: clientId, clientSecret: clientSecret, refreshToken: refreshToken) { result in
            switch result {
            case .success(let info):
                DispatchQueue.main.sync {
                    self.accessToken = info.accessToken
                    self.refreshToken = info.refreshToken
                    self.expiryDate = Date(timeIntervalSinceNow: info.expiresIn - 2 * 60)
                }
                completionHandler?(nil)
            case .failure(let error):
                completionHandler?(error)
            }
        }
    }
    
    public func userInfo(completionHandler: @escaping (Result<KPUser, KPError>) -> ()) {
        API.shared.send(accessToken: accessToken, httpMethod: .get, path: "/v1/user") { result in
            switch result {
            case .success(let response):
                do {
                    completionHandler(.success(try response.decode(key: "user", type: KPUser.self)))
                } catch {
                    completionHandler(.failure(.apiError(.parsingError(error))))
                }
            case .failure(let error):
                completionHandler(.failure(.apiError(error)))
            }
        }
    }
    
    public func allDevices(completionHandler: @escaping (Result<[KPDevice], KPError>) -> ()) {
        API.shared.send(accessToken: accessToken, httpMethod: .get, path: "/v1/device") { result in
            switch result {
            case .success(let response):
                do {
                    completionHandler(.success(try response.decode(key: "devices", type: [KPDevice].self)))
                } catch {
                    completionHandler(.failure(.apiError(.parsingError(error))))
                }
            case .failure(let error):
                completionHandler(.failure(.apiError(error)))
            }
        }
    }
    
    public func currentDevice(completionHandler: @escaping (Result<KPDevice, KPError>) -> ()) {
        API.shared.send(accessToken: accessToken, httpMethod: .get, path: "/v1/device/info") { result in
            switch result {
            case .success(let response):
                do {
                    completionHandler(.success(try response.decode(key: "device", type: KPDevice.self)))
                } catch {
                    completionHandler(.failure(.apiError(.parsingError(error))))
                }
            case .failure(let error):
                completionHandler(.failure(.apiError(error)))
            }
        }
    }
    
    public func getWatchlist(completionHandler: @escaping (Result<[KPWatchingSerial], KPError>) -> ()) {
        API.shared.send(accessToken: accessToken, httpMethod: .get, path: "/v1/watching/serials", queryParams: ["subscribed": "1"]) { result in
            switch result {
            case .success(let response):
                do {
                    completionHandler(.success(try response.decode(key: "items", type: [KPWatchingSerial].self)))
                } catch {
                    completionHandler(.failure(.apiError(.parsingError(error))))
                }
            case .failure(let error):
                completionHandler(.failure(.apiError(error)))
            }
        }
    }
    
    public func getContent(byId id: Int, completionHandler: @escaping (Result<KPContent, KPError>) -> ()) {
        API.shared.send(accessToken: accessToken, httpMethod: .get, path: "/v1/watching", queryParams: ["id": "\(id)"]) { result in
            switch result {
            case .success(let response):
                do {
                    let item: RawData = try response.json().parse(key: "item")
                    if try item.parse(key: "type") == "serial" {
                        completionHandler(.success(try KPSerial(raw: item)))
                    }
                    else {
                        completionHandler(.success(try KPMovie(raw: item)))
                    }
                } catch {
                    completionHandler(.failure(.apiError(.parsingError(error))))
                }
            case .failure(let error):
                completionHandler(.failure(.apiError(error)))
            }
        }
    }
    
    public func getSerial(byId id: Int, completionHandler: @escaping (Result<KPSerial, KPError>) -> ()) {
        API.shared.send(accessToken: accessToken, httpMethod: .get, path: "/v1/watching", queryParams: ["id": "\(id)"]) { result in
            switch result {
            case .success(let response):
                do {
                    completionHandler(.success(try response.decode(key: "item", type: KPSerial.self)))
                } catch {
                    completionHandler(.failure(.apiError(.parsingError(error))))
                }
            case .failure(let error):
                completionHandler(.failure(.apiError(error)))
            }
        }
    }
    
    public func getMovie(byId id: Int, completionHandler: @escaping (Result<KPMovie, KPError>) -> ()) {
        API.shared.send(accessToken: accessToken, httpMethod: .get, path: "/v1/watching", queryParams: ["id": "\(id)"]) { result in
            switch result {
            case .success(let response):
                do {
                    completionHandler(.success(try response.decode(key: "item", type: KPMovie.self)))
                } catch {
                    completionHandler(.failure(.apiError(.parsingError(error))))
                }
            case .failure(let error):
                completionHandler(.failure(.apiError(error)))
            }
        }
    }
    
    public func getMediaLinks(byId id: Int, completionHandler: @escaping (Result<KPMediaLinks, KPError>) -> ()) {
        API.shared.send(accessToken: accessToken, httpMethod: .get, path: "/v1/items/media-links", queryParams: ["mid": "\(id)"]) { result in
            switch result {
            case .success(let response):
                do {
                    try completionHandler(.success(response.decode(type: KPMediaLinks.self)))
                } catch {
                    completionHandler(.failure(.apiError(.parsingError(error))))
                }
            case .failure(let error):
                completionHandler(.failure(.apiError(error)))
            }
        }
    }
    
    public func getVideoLink(byFilename file: String, type: String, completionHandler: @escaping (Result<URL, KPError>) -> ()) {
        API.shared.send(accessToken: accessToken, httpMethod: .get, path: "/v1/items/media-video-link", queryParams: ["file": file, "type": type]) { result in
            switch result {
            case .success(let response):
                do {
                    try completionHandler(.success(response.json().parse(key: "url")))
                } catch {
                    completionHandler(.failure(.apiError(.parsingError(error))))
                }
            case .failure(let error):
                completionHandler(.failure(.apiError(error)))
            }
        }
    }
    
}

@available(tvOS 13.0.0, watchOS 6.0, iOS 13.0.0, macOS 10.15.0, *)
public extension KPSession {
        
    func userInfo() async throws -> KPUser {
        try await withCheckedThrowingContinuation({ continuation in
            userInfo(completionHandler: continuation.resume(with:))
        })
    }
    
}
