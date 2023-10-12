//
//  Dictionary+Parse.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    func parse<T>(key: Key, type: T.Type) throws -> T {
        guard let value = self[key] else {
            throw ParsingError.keyIsMissing(key)
        }
        guard let convertedValue = value as? T else {
            throw ParsingError.wrongType(key: key, expectedType: String(describing: type), actualType: String(describing: Swift.type(of: value)))
        }
        return convertedValue
    }
    
    func parse<T>(type: T.Type) throws -> T {
        guard let convertedValue = self as? T else {
            throw ParsingError.wrongType(key: "", expectedType: String(describing: type), actualType: String(describing: Swift.type(of: self)))
        }
        return convertedValue
    }
    
    func parse(key: Key) throws -> Int {
        return try self.parse(key: key, type: Int.self)
    }
    
    func parse(key: Key) throws -> String {
        return try self.parse(key: key, type: String.self)
    }
    
    func parse(key: Key) throws -> Bool {
        return try self.parse(key: key, type: Bool.self)
    }
    
    func parse(key: Key) throws -> TimeInterval {
        return try self.parse(key: key, type: TimeInterval.self)
    }
    
    func parse(key: Key) throws -> KPJson {
        return try self.parse(key: key, type: KPJson.self)
    }
    
    func parse(key: Key) throws -> Date {
        return try Date(timeIntervalSince1970: self.parse(key: key, type: TimeInterval.self))
    }
    
    func parse(key: Key) throws -> URL {
        guard let url = try URL(string: self.parse(key: key, type: String.self)) else {
            throw ParsingError.valueIsNil(key)
        }
        return url
    }
    
    func parse<T: KPJsonRepresentable>() throws -> T {
        return try T.init(json: self)
    }
    
    func parse<T: KPJsonRepresentable>(key: Key) throws -> T {
        return try T.init(json: self.parse(key: key, type: KPJson.self))
    }
    
    func parse<T: KPJsonRepresentable>(key: Key) throws -> [T] {
        return try self.parse(key: key, type: [KPJson].self).map(T.init(json:))
    }
    
    func parse<T>(path: [Key], type: T.Type) throws -> T {
        var element = self
        for key in path.dropLast() {
            element = try element.parse(key: key, type: KPJson.self)
        }
        return try element.parse(key: path.last!, type: type)
    }
    
    func parse(path: [Key]) throws -> Int {
        return try self.parse(path: path, type: Int.self)
    }
    
    func parse(path: [Key]) throws -> String {
        return try self.parse(path: path, type: String.self)
    }
    
    func parse(path: [Key]) throws -> Bool {
        return try self.parse(path: path, type: Bool.self)
    }
    
    func parse(path: [Key]) throws -> TimeInterval {
        return try self.parse(path: path, type: TimeInterval.self)
    }
    
    func parse(path: [Key]) throws -> KPJson {
        return try self.parse(path: path, type: KPJson.self)
    }
    
    func parse(path: [Key]) throws -> Date {
        return try Date(timeIntervalSince1970: self.parse(path: path, type: TimeInterval.self))
    }
    
    func parse(path: [Key]) throws -> URL {
        guard let url = try URL(string: self.parse(path: path, type: String.self)) else {
            throw ParsingError.valueIsNil(path)
        }
        return url
    }
    
    func parse<T: KPJsonRepresentable>(path: [Key]) throws -> T {
        return try T.init(json: self.parse(path: path, type: KPJson.self))
    }
}
