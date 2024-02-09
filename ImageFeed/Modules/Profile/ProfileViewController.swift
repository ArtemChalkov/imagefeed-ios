//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Артем Чалков on 04.12.2023.
//

import UIKit
import Kingfisher
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    
    var presenter: ProfilePresenterProtocol? { get set }
    
    func configure(_ presenter: ProfilePresenterProtocol)
    
    //Update View
    func setProfile(_ profile: Profile)
    func setAvatar(_ url: URL)
    
    //Navigation
    func showLogoutAlert()
    func navigateToSplashScreen()
}

class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
   
    var presenter: ProfilePresenterProtocol?
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

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
        button.accessibilityIdentifier = "logout button"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        button.addTarget(nil, action: #selector(exitButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var profileNameLabel: UILabel = {
        var label = UILabel()
        label.accessibilityIdentifier = "Name Lastname"
        label.textColor = Colors.ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.clipsToBounds = false
        label.text = "Екатерина Новикова"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nikNameLabel: UILabel = {
        var label = UILabel()
        label.accessibilityIdentifier = "@username"
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
        
        addObserver()
        presenter?.viewDidLoad()
    }
    
    //MARK: - Navigation
    func navigateToSplashScreen() {
        let keyWindow = UIWindow.key
        keyWindow?.rootViewController = SplashViewController()
    }
    
    func showLogoutAlert() {
        let alertModel = AlertModel(title: "Пока, пока!", message: "Уверены что хотите выйти?", buttonText: "Да", cancelText: "Нет")
        
        let refreshAlert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        
        refreshAlert.view.accessibilityIdentifier = "Bye bye!"
        
        let okAction = UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.presenter?.logout()
        })
        okAction.accessibilityIdentifier = "Yes"
    
        refreshAlert.addAction(okAction)
        refreshAlert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    //MARK: - Update View
    func setProfile(_ profile: Profile) {
        
        profileNameLabel.text = profile.name
        nikNameLabel.text = "@\(profile.username)"
        statusLabel.text = profile.bio
    }
    
    func setAvatar(_ url: URL) {
        photoImageView.kf.setImage(with: url)
    }
    
    
    //MARK: Event Pass
    @objc func exitButtonTapped() {
        presenter?.exitButtonTapped()
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
        
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 89).isActive = true
        exitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        profileNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8).isActive = true
        profileNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        nikNameLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8).isActive = true
        nikNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        statusLabel.topAnchor.constraint(equalTo: nikNameLabel.bottomAnchor, constant: 8).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
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
    }
    
}
