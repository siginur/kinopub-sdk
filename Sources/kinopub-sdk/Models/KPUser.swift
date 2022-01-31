//
//  KPUser.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPUser: Codable, Equatable, DecodableFromRawData {
    public let username: String
    public let name: String
    public let avatar: URL
    public let registrationDate: Date
    public let subscriptionExpiryDate: Date
    
    required init(raw: RawData) throws {
        username = try raw.parse(key: "username")
        registrationDate = try raw.parse(key: "reg_date")
        name = try raw.parse(path: ["profile", "name"])
        avatar = try raw.parse(path: ["profile", "avatar"])
        subscriptionExpiryDate = try raw.parse(path: ["subscription", "end_time"])
    }
    
    public init(username: String, name: String, avatar: URL, registrationDate: Date, subscriptionExpiryDate: Date) {
        self.username = username
        self.name = name
        self.avatar = avatar
        self.registrationDate = registrationDate
        self.subscriptionExpiryDate = subscriptionExpiryDate
    }
    
    public static func == (lhs: KPUser, rhs: KPUser) -> Bool {
        return lhs.username == rhs.username &&
        lhs.name == rhs.name &&
        lhs.avatar == rhs.avatar &&
        lhs.registrationDate == rhs.registrationDate &&
        lhs.subscriptionExpiryDate == rhs.subscriptionExpiryDate
    }
}
