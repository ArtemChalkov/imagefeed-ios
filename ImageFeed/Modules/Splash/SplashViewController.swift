//
//  SplashViewController.swift
//  ImageFeed
//


import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    
    let oauth2TokenStorage = OAuth2TokenStorage()
    let oauth2Service = OAuth2Service()
    let profileService = ProfileService.shared
    let profileImageService = ProfileImageService.shared
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //ProgressHUD.show()
        UIBlockingProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            let accessToken = self.oauth2TokenStorage.token
            
            self.fetchProfile(token: accessToken)
            
            if accessToken.isEmpty {
                self.navigateToAuthScreen()
                UIBlockingProgressHUD.dismiss()
            } else {
                self.navigateToFeedScreen()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func setupViews() {
        view.backgroundColor = Colors.ypBlack
        view.addSubview(logoImageView)
    }
    
    func setupConstraints() {
        
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 367).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 77.68).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
    }
    
    func navigateToAuthScreen() {
        
        let authVC = AuthViewController()
        let navigationVC = UINavigationController(rootViewController: authVC)
        
        authVC.delegate = self
        
        let keyWindow = UIWindow.key
        keyWindow?.rootViewController = navigationVC
    }
    
    func navigateToFeedScreen() {
        
        let tabBarVC = TabBarController()
        let keyWindow = UIWindow.key
        keyWindow?.rootViewController = tabBarVC
    }
}

//MARK: - Business Logic
extension SplashViewController {
    
    func fetchProfile(token: String) {
    
            profileService.fetchProfile(token) { result in
                switch result {
    
                case .success(let profile):
                    
                    print(profile)
                    
                    self.profileImageService.fetchProfileImageURL(username: profile.username) { result in
                        switch result {
                            
                        case .success(let profileImageURL):
                            
                            NotificationCenter.default                                     // 1
                                .post(                                                     // 2
                                    name: ProfileImageService.DidChangeNotification,       // 3
                                    object: self,                                          // 4
                                    userInfo: ["URL": profileImageURL])
                            
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                    
                    
                    
    
                case .failure(let error):
                    print(error)
                }
            }
        }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        UIBlockingProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.oauth2Service.fetchAuthToken(code: code) { result in

                switch result {

                case .success(let accessToken):

                    print(accessToken)

                    self.oauth2TokenStorage.token = accessToken
                    
                    self.fetchProfile(token: accessToken)

                    let keyWindow = UIWindow.key

                    let tabBarVC = TabBarController()
                    keyWindow?.rootViewController = tabBarVC
                    
                    UIBlockingProgressHUD.dismiss()


                case .failure(let error):
                    print(error)
                    UIBlockingProgressHUD.dismiss()
                }
            }

            
        }
        
    }
}

