//
//  File.swift
//  
//
//  Created by Alexey Siginur on 30/01/2022.
//

import Foundation

public protocol KPJsonRepresentable {
    init(json: KPJson) throws
    init(jsonData: Data) throws
}
public extension KPJsonRepresentable {
    init(jsonData: Data) throws {
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let jsonData = jsonObject as? KPJson else {
            throw ParsingError.wrongType(key: NSNull(), expectedType: String(describing: KPJson.self), actualType: String(describing: Swift.type(of: jsonObject).self))
        }
        try self.init(json: jsonData)
    }
}

protocol CouldBeInWatchList: KPContentMetadata {}
extension CouldBeInWatchList {
    public func toggleWatchList(session: KPSession? = KPSession.current, completionHandler: @escaping (Result<Bool, KPError>) -> ()) {
        API.shared.send(accessToken: session?.accessToken, httpMethod: .get, path: "/v1/watching/togglewatchlist", queryParams: ["id": "\(self.id)"]) { result in
            switch result {
            case .success(let response):
                do {
                    completionHandler(.success(try response.json().parse(key: "watching")))
                } catch {
                    completionHandler(.failure(.apiError(.parsingError(error))))
                }
            case .failure(let error):
                completionHandler(.failure(.apiError(error)))
            }
        }
    }
}


// MARK: - Async/Await wrappers

@available(tvOS 13.0.0, watchOS 6.0, iOS 13.0.0, macOS 10.15.0, *)
extension CouldBeInWatchList {
    
    public func toggleWatchList(session: KPSession? = KPSession.current) async throws -> Bool {
        try await withCheckedThrowingContinuation({ continuation in
            toggleWatchList(session: session, completionHandler: continuation.resume(with:))
        })
    }
    
}
