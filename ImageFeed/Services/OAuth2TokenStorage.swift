//
//  OAuth2TokenStorage.swift
//  ImageFeed
//


import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String { get set }
}

final class OAuth2TokenStorage:  OAuth2TokenStorageProtocol{
    
    private let userDefaults = UserDefaults.standard
    
    private let keychain = KeychainWrapper.standard
    
    private let key = "New Token"
    
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
