//
//  Errors.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public enum HTTPError: Error, CustomStringConvertible {
    case other(Error)
    case noResponseData

    public var localizedDescription: String {
        switch self {
        case .other(let error):
            return "HTTP Error: \(error)"
        case .noResponseData:
            return "Recieved response without data"
        }
    }
    
    public var description: String { localizedDescription }
}

public enum APIError: Error, CustomStringConvertible {
    case httpError(HTTPError)
    case invalidURL(String)
    case parsingError(Error)
    case notAuthorized
    case authorizationPending
    case apiErrorResponse(APIErrorResponse)
    
    public var localizedDescription: String {
        switch self {
        case .httpError(let error):
            return "API Error: \(error)"
        case .invalidURL(let url):
            return "Invalid url: \(url)"
        case .parsingError(let error):
            return "Parsing error: \(error)"
        case .notAuthorized:
            return "Not authorized"
        case .authorizationPending:
            return "Pending authorization"
        case .apiErrorResponse(let response):
            return "API response error: \(response.message)"
        }
    }
    
    public var description: String { localizedDescription }
}

public enum ParsingError: Error, CustomStringConvertible {
    case keyIsMissing(AnyHashable)
    case wrongType(key: AnyHashable, expectedType: String, actualType: String)
    case conversion(key: AnyHashable, sourceType: String, targetType: String)
    case valueIsNil(AnyHashable)
    
    public var localizedDescription: String {
        switch self {
        case .keyIsMissing(let key):
            return "ParsingError: key '\(key)' is missing"
        case .wrongType(let key, let expectedType, let actualType):
            return "ParsingError: expected type is \(expectedType), actual type is \(actualType) for key '\(key)'"
        case .conversion(let key, let sourceType, let targetType):
            return "ParsingError: conversion failed from type \(sourceType) to type \(targetType) for key '\(key)'"
        case .valueIsNil(let key):
            return "ParsingError: value for key '\(key)' is null"
        }
    }
    
    public var description: String { localizedDescription }
}

public enum KPError: Error, CustomStringConvertible {
    case noRefreshToken
    case noActiveSession
    case wrongInputParameters
    case apiError(APIError)
    case other(Error)
    
    public var localizedDescription: String {
        switch self {
        case .noRefreshToken:
            return "Refresh token not found"
        case .noActiveSession:
            return "Active session not found"
        case .wrongInputParameters:
            return "Wrong input parameters"
        case .apiError(let error):
            return error.localizedDescription
        case .other(let error):
            return error.localizedDescription
        }
    }
    
    public var description: String { localizedDescription }
}
