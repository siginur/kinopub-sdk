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
    
//    private var retriexws = 0
//    static let clientId: String = "plex"
//    static let clientSecret: String = "h2zx6iom02t9cxydcmbo9oi0llld7jsv"
//    static var accessToken: String = {
//        return UserDefaults.standard.string(forKey: "accessToken") ?? ""
//    }()
//    static var refreshToken: String = {
//        return UserDefaults.standard.string(forKey: "refreshToken") ?? ""
//    }()

    private let queue: DispatchQueue
    private let session: URLSession
//    var tasks = Dictionary<ApiMethod, (task: URLSessionDataTask, progressBlock: ((Int64, Int64, Int64) -> ())?)>()
    
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
        
        sendRaw(httpMethod: httpMethod, url: url) { result in
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

public class APIResponse {
    public let statusCode: Int
    public let data: Data
    public var isError: Bool { false }
    
    init(data: Data, response: HTTPURLResponse) {
        self.statusCode = response.statusCode
        self.data = data
    }
    
    func json() throws -> RawData {
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        guard let convertedObject = object as? RawData else {
            throw ParsingError.wrongType(key: NSNull(), expectedType: String(describing: RawData.self), actualType: String(describing: Swift.type(of: object)))
        }
        return convertedObject
    }
    
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    func decode<T: DecodableFromRawData>(type: T.Type) throws -> T {
        return try T.init(raw: json())
    }
    
    func decode<T: DecodableFromRawData>(key: String, type: T.Type) throws -> T {
        return try T.init(raw: json().parse(key: key))
    }
    
    func decode<T: DecodableFromRawData>(path: [String], type: T.Type) throws -> T {
        return try T.init(raw: json().parse(path: path))
    }
    
    func decode<T: DecodableFromRawData>(key: String, type: [T].Type) throws -> [T] {
        return try json().parse(key: key, type: [RawData].self).map(T.init(raw:))
    }
    
    func decode<T: DecodableFromRawData>(path: [String], type: [T].Type) throws -> [T] {
        return try json().parse(path: path, type: [RawData].self).map(T.init(raw:))
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