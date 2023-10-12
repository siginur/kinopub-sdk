//
//  API.swift
//  
//
//  Created by Alexey Siginur on 28/01/2022.
//

import Foundation

class API {
    
    static let shared = API()
    private static let server = "https://api.service-kp.com"
    private static let standardHeaders = [
        "Content-Type": "application/json",
        "Cache-Control": "no-store"
    ]

    private let queue: DispatchQueue
    private let session: URLSession
    
    private init() {
        queue = DispatchQueue(label: "com.merkova.kinopub-sdk.api-queue", qos: .default)
        session = URLSession.shared
    }
    
    func getDeviceCode(clientId: String, clientSecret: String, completionHandler: @escaping (Result<AuthenticationDeviceInfo, APIError>) -> ()) {
        let params = [
            "grant_type": "device_code",
            "client_id": clientId,
            "client_secret": clientSecret
        ]
        
        send(httpMethod: .post, path: "/oauth2/device", queryParams: params) { result in
            switch result {
            case .success(let response):
                do {
                    completionHandler(.success(try response.decode(AuthenticationDeviceInfo.self)))
                } catch {
                    completionHandler(.failure(.parsingError(error)))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getAccessToken(clientId: String, clientSecret: String, code: String, completionHandler: @escaping (Result<AuthenticationUserInfo, APIError>) -> ()) {
        let params = [
            "grant_type": "device_token",
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": code
        ]
        
        send(httpMethod: .post, path: "/oauth2/device", queryParams: params) { result in
            switch result {
            case .success(let response):
                do {
                    completionHandler(.success(try response.decode(AuthenticationUserInfo.self)))
                } catch {
                    completionHandler(.failure(.parsingError(error)))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func refreshAccessToken(clientId: String, clientSecret: String, refreshToken: String, completionHandler: @escaping (Result<AuthenticationUserInfo, APIError>) -> ()) {
        let params = [
            "grant_type": "refresh_token",
            "client_id": clientId,
            "client_secret": clientSecret,
            "refresh_token": refreshToken
        ]
        
        send(httpMethod: .post, path: "/oauth2/token", queryParams: params) { result in
            switch result {
            case .success(let response):
                do {
                    completionHandler(.success(try response.decode(AuthenticationUserInfo.self)))
                } catch {
                    completionHandler(.failure(.parsingError(error)))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func send(accessToken: String? = nil, httpMethod: HTTPMethod, path: String, queryParams: [String: String] = [:], body: Data? = nil, completionHandler: @escaping (Result<APIResponse, APIError>) -> ()) {
        let urlString = Self.server + path + queryParams.queryString() + (accessToken != nil ? "&access_token=\(accessToken!)" : "")
        guard let url = URL(string: urlString) else {
            queue.async {
                completionHandler(.failure(APIError.invalidURL(urlString)))
            }
            return
        }
        
        sendRaw(httpMethod: httpMethod, url: url, body: body) { result in
            switch result {
            case .success((let data, let response)):
                if response.statusCode == 200 {
                    completionHandler(.success(APIResponse(data: data, response: response)))
                }
                else {
                    completionHandler(.failure(.apiErrorResponse(APIErrorResponse(data: data, response: response))))
                }
            case .failure(let error):
                completionHandler(.failure(.httpError(error)))
            }
        }
    }
    
    fileprivate func sendRaw(httpMethod: HTTPMethod, url: URL, body: Data? = nil, headers: [String: String] = standardHeaders, completionHandler: @escaping (Result<(data: Data, response: HTTPURLResponse), HTTPError>) -> ()) {
        queue.async {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            request.httpBody = body
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            let task = self.session.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    completionHandler(.failure(.other(error!)))
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    completionHandler(.failure(.noResponseData))
                    return
                }
                
                completionHandler(.success((data, response)))
            }
            
            task.resume()
        }
    }
}

@available(iOS 13.0.0, *)
extension API {
    func getDeviceCode(clientId: String, clientSecret: String, completionHandler: @escaping (Result<AuthenticationDeviceInfo, APIError>) -> ()) async throws -> AuthenticationDeviceInfo {
        let params = [
            "grant_type": "device_code",
            "client_id": clientId,
            "client_secret": clientSecret
        ]
        
        let response = try await send(httpMethod: .post, path: "/oauth2/device", queryParams: params)
        return try response.decode(AuthenticationDeviceInfo.self)
    }
    
    func getAccessToken(clientId: String, clientSecret: String, code: String) async throws -> AuthenticationUserInfo {
        let params = [
            "grant_type": "device_token",
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": code
        ]
        
        let response = try await send(httpMethod: .post, path: "/oauth2/device", queryParams: params)
        return try response.decode(AuthenticationUserInfo.self)
    }
    
    func refreshAccessToken(clientId: String, clientSecret: String, refreshToken: String) async throws -> AuthenticationUserInfo {
        let params = [
            "grant_type": "refresh_token",
            "client_id": clientId,
            "client_secret": clientSecret,
            "refresh_token": refreshToken
        ]
        
        let response = try await send(httpMethod: .post, path: "/oauth2/token", queryParams: params)
        return try response.decode(AuthenticationUserInfo.self)
    }
    
    func send(accessToken: String? = nil, httpMethod: HTTPMethod, path: String, queryParams: [String: String] = [:], body: Data? = nil) async throws -> APIResponse {
        let urlString = Self.server + path + queryParams.queryString() + (accessToken != nil ? "&access_token=\(accessToken!)" : "")
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL(urlString)
        }
        
        let (data, response) = try await sendRaw(httpMethod: httpMethod, url: url, body: body)
        guard response.statusCode == 200 else {
            throw APIError.apiErrorResponse(APIErrorResponse(data: data, response: response))
        }
        
        return APIResponse(data: data, response: response)
    }
    
    fileprivate func sendRaw(httpMethod: HTTPMethod, url: URL, body: Data? = nil, headers: [String: String] = standardHeaders) async throws -> (data: Data, response: HTTPURLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await self.session.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw HTTPError.noResponseData
        }
        return (data, response)
    }
}

public class APIResponse {
    public let statusCode: Int
    public let data: Data
    public var isError: Bool { false }
    
    init(data: Data, response: HTTPURLResponse) {
        self.statusCode = response.statusCode
        self.data = data
    }
    
    func json() throws -> KPJson {
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        guard let convertedObject = object as? KPJson else {
            throw ParsingError.wrongType(key: NSNull(), expectedType: String(describing: KPJson.self), actualType: String(describing: Swift.type(of: object)))
        }
        return convertedObject
    }
    
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    func decode<T: KPJsonRepresentable>(type: T.Type) throws -> T {
        return try T.init(json: json())
    }
    
    func decode<T: KPJsonRepresentable>(key: String, type: T.Type) throws -> T {
        return try T.init(json: json().parse(key: key))
    }
    
    func decode<T: KPJsonRepresentable>(path: [String], type: T.Type) throws -> T {
        return try T.init(json: json().parse(path: path))
    }
    
    func decode<T: KPJsonRepresentable>(key: String, type: [T].Type) throws -> [T] {
        return try json().parse(key: key, type: [KPJson].self).map(T.init(json:))
    }
    
    func decode<T: KPJsonRepresentable>(path: [String], type: [T].Type) throws -> [T] {
        return try json().parse(path: path, type: [KPJson].self).map(T.init(json:))
    }
    
    func decode<T: KPJsonRepresentable>(key: String, type: [String: T].Type) throws -> [String: T] {
        return try json().parse(key: key, type: [String: KPJson].self).mapValues(T.init(json:))
    }
    
    func decode<T: KPJsonRepresentable>(path: [String], type: [String: T].Type) throws -> [String: T] {
        return try json().parse(path: path, type: [String: KPJson].self).mapValues(T.init(json:))
    }
    
    func decode<T: KPJsonRepresentable>(key: String, type: [String: [T]].Type) throws -> [String: [T]] {
        return try json().parse(key: key, type: [String: [KPJson]].self).mapValues({ try $0.map(T.init(json:)) })
    }
    
    func decode<T: KPJsonRepresentable>(path: [String], type: [String: [T]].Type) throws -> [String: [T]] {
        return try json().parse(path: path, type: [String: [KPJson]].self).mapValues({ try $0.map(T.init(json:)) })
    }
}

public class APIErrorResponse: APIResponse {
    
    public override var isError: Bool { true }
    
    public lazy var message: String = {
        guard let dict = try? json() else {
            return "<<unknown error>>"
        }
        return dict["message"] as? String ?? dict["error"] as? String ?? "<<unknown error>>"
    }()
    
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

fileprivate extension Dictionary where Key == String, Value == String {
    func queryString() -> String {
        var params: [String] = []
        for (key, value) in self {
            let keyValue = "\(key)=\(value)"
            params.append(keyValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? keyValue)
        }
        return "?" + params.joined(separator: "&")
    }
}
