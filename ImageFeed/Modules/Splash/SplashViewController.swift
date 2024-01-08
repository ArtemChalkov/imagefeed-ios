//
//  SplashViewController.swift
//  ImageFeed
//


import UIKit

class SplashViewController: UIViewController {
    
    let oauth2TokenStorage = OAuth2TokenStorage()
    let oauth2Service = OAuth2Service()
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            if self.oauth2TokenStorage.token.isEmpty {
                self.navigateToAuthScreen()
            } else {
                self.navigateToFeedScreen()
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

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        oauth2Service.fetchAuthToken(code: code) { result in

            switch result {

            case .success(let accessToken):

                print(accessToken)

                self.oauth2TokenStorage.token = accessToken

                let keyWindow = UIWindow.key

                let tabBarVC = TabBarController()
                keyWindow?.rootViewController = tabBarVC


            case .failure(let error):
                print(error)
            }
        }
    }
}

