//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Артем Чалков on 04.12.2023.
//

import UIKit
import Kingfisher
import WebKit

class ProfileViewController: UIViewController {
    
    let profileService = ProfileService.shared
    let oauthTokenStorage = OAuth2TokenStorage()
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Profile")
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var exitButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        button.addTarget(nil, action: #selector(exitButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    @objc func exitButtonTapped() {
        
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
        
        var keyWindow = UIWindow.key
        
        keyWindow?.rootViewController = SplashViewController()
    }
    
    var profileNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = Colors.ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.clipsToBounds = false
        label.text = "Екатерина Новикова"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nikNameLabel: UILabel = {
        var label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = Colors.ypGray //UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13)//UIFont(name: "SFPro-Regular", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var statusLabel: UILabel = {
        var label = UILabel()
        label.text = "Hello, world!"
        label.textColor = Colors.ypWhite //UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        fetchProfile()
        
        if let avatarURL = ProfileImageService.shared.avatarURL,// 16
           let url = URL(string: avatarURL) {                   // 17
            // TODO [Sprint 11]  Обновить аватар, если нотификация
            // была опубликована до того, как мы подписались.
            
            //let imageUrl = URL(string: imageUrlPath)!
            photoImageView.kf.setImage(with: url)
        }
    }
    
    func fetchProfile() {
        
        if let profile = profileService.profile {
            self.profileNameLabel.text = profile.name
            self.nikNameLabel.text = "@\(profile.username)"
            self.statusLabel.text = profile.bio
        }
    }

    func setupViews() {
        view.backgroundColor = Colors.ypBlack
        view.addSubview(photoImageView)
        view.addSubview(exitButton)
        view.addSubview(profileNameLabel)
        view.addSubview(nikNameLabel)
        view.addSubview(statusLabel)
    }
    
    func setupConstraints() {
        photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        //photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -289).isActive = true
       
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 89).isActive = true
        //exitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 315).isActive = true
        exitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        profileNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8).isActive = true
        profileNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        //profileNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -118).isActive = true
       
        nikNameLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8).isActive = true
        nikNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        //nikNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -260).isActive = true
       
        statusLabel.topAnchor.constraint(equalTo: nikNameLabel.bottomAnchor, constant: 8).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        //statusLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -282).isActive = true
    }
    
    deinit {
        removeObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(                 // 1
            self,                                               // 2
            selector: #selector(updateAvatar(notification:)),   // 3
            name: ProfileImageService.DidChangeNotification,    // 4
            object: nil)                                        // 5
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(              // 6
            self,                                               // 7
            name: ProfileImageService.DidChangeNotification,    // 8
            object: nil)                                        // 9
    }
    
    @objc                                                       // 10
    private func updateAvatar(notification: Notification) {     // 11
        guard
            isViewLoaded,                                       // 12
            let userInfo = notification.userInfo,               // 13
            let profileImageURL = userInfo["URL"] as? String,   // 14
            let url = URL(string: profileImageURL) // 15
        else { return }
        
        photoImageView.kf.setImage(with: url)
        
        // TODO [Sprint 11] Обновить аватар, используя Kingfisher
    }
    
}
