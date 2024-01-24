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
    let alertPresenter = AlertPresenter()
    
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

            if accessToken.isEmpty {
                self.navigateToAuthScreen()
                UIBlockingProgressHUD.dismiss()
            } else {

                self.fetchProfile(token: accessToken) { //[weak self] in

                    //guard let self = self else { return }

                    self.navigateToFeedScreen()
                    UIBlockingProgressHUD.dismiss()
                }
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
    
    func fetchProfile(token: String, success: @escaping () -> Void) {
    
            profileService.fetchProfile(token) {  result in
                
                //guard let self else { return }
                
                switch result {
                    
                
                case .success(let profile):
                    
                    print(profile)
                    
                    self.profileImageService.fetchProfileImageURL(username: profile.username) { result in
                        switch result {

                        case .success(let profileImageURL):

                            success()

                            NotificationCenter.default                                     // 1
                                .post(                                                     // 2
                                    name: ProfileImageService.DidChangeNotification,       // 3
                                    object: self,                                          // 4
                                    userInfo: ["URL": profileImageURL])

                        case .failure(let error):
                            print(error)


                            self.showAlert()

                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    
                    self.showAlert()
                }
            }
        }
    
    
    func showAlert() {

        //let keyWindow = UIWindow.key
        let alertModel = AlertModel(title: "Что-то пошло не так", message: "Не удалось войти в систему", buttonText: "Ок")

        let alertPresenter = AlertPresenter()

        alertPresenter.show(model: alertModel, controller: self)

        alertPresenter.completion = {
            print("alert", #line)

        }
        
        
        //guard let controller = keyWindow?.rootViewController else { return }

        //print("->", controller)
        
//        var dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
//        
//        // Create OK button with action handler
//        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//            print("Ok button tapped")
//         })
//        
//        //Add OK button to a dialog message
//        dialogMessage.addAction(ok)
//        // Present Alert to
//        self.present(dialogMessage, animated: true, completion: nil)
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
                    
                    UIBlockingProgressHUD.dismiss()
                    
                    self.fetchProfile(token: accessToken) {
                        let keyWindow = UIWindow.key

                        let tabBarVC = TabBarController()
                        keyWindow?.rootViewController = tabBarVC
                        
                        UIBlockingProgressHUD.dismiss()
                    }

                   


                case .failure(let error):
                    print(error)
                    self.showAlert()
                    
                    UIBlockingProgressHUD.dismiss()
                }
            }

            
        }
        
    }
}

