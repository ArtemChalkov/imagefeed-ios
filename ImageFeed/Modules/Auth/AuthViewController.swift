//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Артем Чалков on 18.12.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController:  UIViewController {
    
    var delegate: AuthViewControllerDelegate?
    

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
        
        print(Thread.current)
        let webViewVC = WebViewViewController()
        webViewVC.modalPresentationStyle = .fullScreen
        webViewVC.delegate = self
        present(webViewVC, animated: true)
    }
}



extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        vc.dismiss(animated: true)
        print("code ->", code)
        
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        
        self.dismiss(animated: true)

        //let keyWindow = UIWindow.key
        
        //keyWindow?.rootViewController = SplashViewController()
        
        //TODO: POST request
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

