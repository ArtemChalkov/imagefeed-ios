//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Artur Igberdin on 18.12.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

class WebViewViewController: UIViewController {
    
    weak var delegate: WebViewViewControllerDelegate?
    
    var progressView: UIProgressView = {
       
        let progressView = UIProgressView.init(progressViewStyle: .default)
        progressView.tintColor = Colors.ypBackground
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "nav_back_button"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.addTarget(nil, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func backButtonTapped() {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        webView.navigationDelegate = self
        return webView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadRequest()
    }
    
    func loadRequest() {
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!  //1
        urlComponents.queryItems = [
           URLQueryItem(name: "client_id", value: AccessKey),                  //2
           URLQueryItem(name: "redirect_uri", value: RedirectURI),             //3
           URLQueryItem(name: "response_type", value: "code"),                 //4
           URLQueryItem(name: "scope", value: AccessScope)                     //5
         ]
        let url = urlComponents.url!
        //let url = URL(string: "https://www.youtube.com/watch?v=695PN9xaEhs")!
        print(url)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
       
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(backButton)
        view.addSubview(progressView)
    }
    func setupConstraints() {
        
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        
        
        progressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87).isActive = true
        progressView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        progressView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        //navigationController?.navigationItem.titleView?.addSubview(progressView)
        
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
