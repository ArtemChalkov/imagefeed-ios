//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Артем Чалков on 18.12.2023.
//

import UIKit

final class AuthViewController:  UIViewController {
    
    let oauth2Service = OAuth2Service()
    let oauth2TokenStorage = OAuth2TokenStorage()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Logo_of_Unsplash")
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return imageView
    }()
    
    var enterButton: UIButton = {
       var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(Colors.ypBlack, for: .normal)
        button.backgroundColor = Colors.ypWhite
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        button.addTarget(nil, action: #selector(enterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = Colors.ypBlack
        view.addSubview(logoImageView)
        view.addSubview(enterButton)
    }
    
    func setupConstraints() {
        
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor,constant: 376).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        enterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124).isActive = true
        enterButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        enterButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        enterButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
   
    @objc func enterButtonTapped() {

        let webViewVC = WebViewViewController()
        webViewVC.modalPresentationStyle = .fullScreen
        webViewVC.delegate = self
        present(webViewVC, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        print("code ->", code)
        
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
        
        //TODO: POST request
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

