//
//  WebViewPresenter.swift
//  ImageFeed
//
//

import UIKit

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    
    //View Event
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    
    //Business Logic
    //func loadRequest()
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    var authHelper: AuthHelperProtocol
       
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
//    func code(from url: URL) -> String? {
//        if let urlComponents = URLComponents(string: url.absoluteString),
//           urlComponents.path == "/oauth/authorize/native",
//           let items = urlComponents.queryItems,
//           let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
//    }
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    weak var view: WebViewViewControllerProtocol?
    
//    func loadRequest() {
//
//        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!  //1
//        urlComponents.queryItems = [
//           URLQueryItem(name: "client_id", value: AccessKey),                  //2
//           URLQueryItem(name: "redirect_uri", value: RedirectURI),             //3
//           URLQueryItem(name: "response_type", value: "code"),                 //4
//           URLQueryItem(name: "scope", value: AccessScope)                     //5
//         ]
//        let url = urlComponents.url!
//        print(url)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let request = URLRequest(url: url)
//            //self.webView.load(request)
//
//            self.didUpdateProgressValue(0)
//
//            self.view?.load(request: request)
//        }
//    }
    
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    
    
}
