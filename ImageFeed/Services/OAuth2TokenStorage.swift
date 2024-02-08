//
//  OAuth2TokenStorage.swift
//  ImageFeed
//


import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    let userDefaults = UserDefaults.standard
    
    let keychain = KeychainWrapper.standard
    
    let key = "New Token"
    
    var token: String {
        get {
            //return userDefaults.string(forKey: key) ?? ""
            print("->", keychain.string(forKey: key) ?? "")
            return keychain.string(forKey: key) ?? ""
        }
        
        set(newValue) {
            //userDefaults.set(newValue, forKey: key)
            
            keychain.set(newValue, forKey: key)
            print("->", keychain.set(newValue, forKey: key))
        }
    }

}
