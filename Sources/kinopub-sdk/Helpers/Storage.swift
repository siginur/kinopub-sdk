//
//  Storage.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation
import SMStorage

struct Storage {
    
    private let userDefaults = SMStorage<SettingsKey>(userDefaults: UserDefaults.standard)
    
    private init() {}
    
}

extension Storage {
    
    struct Auth {
        
        enum Key: String, StorageKey {
            case clientId
            case clientSecret
            case deviceName
            
            var key: String { rawValue }
        }
        
        private static let storage = SMStorage<Key>(memoryInitial: [:])
        
        static var clientId: String {
            get { storage[.clientId].string ?? "" }
            set { storage[.clientId] = newValue}
        }
        
        static var clientSecret: String {
            get { storage[.clientSecret].string ?? "" }
            set { storage[.clientSecret] = newValue}
        }
        
        static var deviceName: String? {
            get { storage[.deviceName].string }
            set { storage[.deviceName] = newValue}
        }
        
    }
    
}

enum SettingsKey: String, StorageKey {

    case accessToken
    case refreshToken
    case tokenExpiryDate

    var key: String { "com.merkova.kinopub-sdk." + rawValue }
}
