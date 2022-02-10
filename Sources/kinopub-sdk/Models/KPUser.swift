//
//  KPUser.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPUser: Codable, Hashable, Identifiable, KPJsonRepresentable {
    
    public let username: String
    public let name: String
    public let avatar: URL
    public let registrationDate: Date
    public let subscriptionExpiryDate: Date
    
    public required init(json: KPJson) throws {
        username = try json.parse(key: "username")
        registrationDate = try json.parse(key: "reg_date")
        name = try json.parse(path: ["profile", "name"])
        avatar = try json.parse(path: ["profile", "avatar"])
        subscriptionExpiryDate = try json.parse(path: ["subscription", "end_time"])
    }
    
    public init(username: String, name: String, avatar: URL, registrationDate: Date, subscriptionExpiryDate: Date) {
        self.username = username
        self.name = name
        self.avatar = avatar
        self.registrationDate = registrationDate
        self.subscriptionExpiryDate = subscriptionExpiryDate
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(username)
        hasher.combine(name)
        hasher.combine(avatar)
        hasher.combine(registrationDate)
        hasher.combine(subscriptionExpiryDate)
    }
    
    public static func == (lhs: KPUser, rhs: KPUser) -> Bool {
        return lhs.username == rhs.username &&
        lhs.name == rhs.name &&
        lhs.avatar == rhs.avatar &&
        lhs.registrationDate == rhs.registrationDate &&
        lhs.subscriptionExpiryDate == rhs.subscriptionExpiryDate
    }
    
}
