//
//  AuthenticationInfo.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation

struct AuthenticationDeviceInfo: Decodable {
    
    let code: String
    let userCode: String
    let verificationURL: String
    let interval: TimeInterval
    let expiresIn: TimeInterval
    
    private enum JSONKeys: String, CodingKey {
        case code
        case user_code
        case verification_uri
        case interval
        case expires_in
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JSONKeys.self)
        code = try values.decode(String.self, forKey: .code)
        userCode = try values.decode(String.self, forKey: .user_code)
        verificationURL = try values.decode(String.self, forKey: .verification_uri)
        interval = try values.decode(TimeInterval.self, forKey: .interval)
        expiresIn = try values.decode(TimeInterval.self, forKey: .expires_in)
    }
    
}

struct AuthenticationUserInfo: Decodable {
    
    let accessToken: String
    let refreshToken: String
    let expiresIn: TimeInterval
    
    private enum JSONKeys: String, CodingKey {
        case access_token
        case refresh_token
        case expires_in
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JSONKeys.self)
        accessToken = try values.decode(String.self, forKey: .access_token)
        refreshToken = try values.decode(String.self, forKey: .refresh_token)
        expiresIn = try values.decode(TimeInterval.self, forKey: .expires_in)
    }
    
}
