//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Artur Igberdin on 28.12.2023.
//

import Foundation

class OAuth2TokenStorage {
    
    let userDefaults = UserDefaults.standard
    
    let key = "Bearer Token"
    
    var token: String {
        get {
            return userDefaults.string(forKey: key) ?? ""
        }
        
        set(newValue) {
            userDefaults.set(newValue, forKey: key)
        }
    }
    
//    func set(bearerToken: String) {
//        userDefaults.set(bearerToken, forKey: key)
//    }
//
//    func get() -> String {
//        return userDefaults.string(forKey: key) ?? ""
//    }
}
