//
//  ProfilePresenter.swift
//  ImageFeed
//

import Foundation
import WebKit

protocol ProfilePresenterProtocol: AnyObject {
    //Dependencies
    var view: ProfileViewControllerProtocol? { get set }
    
    //View Event
    func viewDidLoad()
    func exitButtonTapped()
    
    //Business Logic
    func fetchProfile()
    func fetchAvatar()
    func logout()
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    //Dependencies
    weak var view: ProfileViewControllerProtocol?
    
    let profileService: ProfileServiceProtocol //= ProfileService.shared
    let oauthTokenStorage: OAuth2TokenStorageProtocol //= OAuth2TokenStorage()
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared,
         oauthTokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage()) {
        self.profileService = profileService
        self.oauthTokenStorage = oauthTokenStorage
    }
    
    func viewDidLoad() {
        
        fetchProfile()
        fetchAvatar()
    }
    
    func exitButtonTapped() {
        
        view?.showLogoutAlert()
    }
    
    func logout() {
        func clean() {
            // Очищаем все куки из хранилища.
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            // Запрашиваем все данные из локального хранилища.
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                // Массив полученных записей удаляем из хранилища.
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                }
            }
        }
        clean()
        OAuth2TokenStorage().token = ""
        
        view?.navigateToSplashScreen()
    }
    
    func fetchAvatar() {
        if let avatarURL = ProfileImageService.shared.avatarURL,
           let url = URL(string: avatarURL) {
            view?.setAvatar(url)
        }
    }
    
    func fetchProfile() {
        if let profile = profileService.profile {
            view?.setProfile(profile)
        }
    }
}

