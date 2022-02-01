//
//  Storage.swift
//  
//
//  Created by Alexey Siginur on 29/01/2022.
//

import Foundation
import SMStorage

struct Storage {
    
    struct Auth {
        
        private static let storage = SMStorage.memory()
        
        static var clientId: String {
            get { storage["clientId"] ?? "" }
            set { storage["clientId"] = newValue}
        }
        
        static var clientSecret: String {
            get { storage["clientSecret"] ?? "" }
            set { storage["clientSecret"] = newValue}
        }
        
        static var deviceName: String? {
            get { storage["deviceName"] }
            set { storage["deviceName"] = newValue}
        }
        
    }
    
}
