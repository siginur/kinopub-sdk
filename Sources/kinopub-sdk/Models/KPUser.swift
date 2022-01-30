//
//  KPUser.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

public class KPUser: DecodableFromRawData {
    
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
}
