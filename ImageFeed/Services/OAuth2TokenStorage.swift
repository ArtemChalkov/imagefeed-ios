//
//  OAuth2TokenStorage.swift
//  ImageFeed
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

}
