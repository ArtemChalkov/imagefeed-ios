//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Артем Чалков on 04.12.2023.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var photoUrl: URL?
    
    var photo: Photo?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 1
        scrollView.delegate = self
        
        return scrollView
    }()
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Backward"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        button.addTarget(nil, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var shareButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Sharing"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.addTarget(nil, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = Colors.ypBlack
        
        return button
    }()
    
    func update(_ photo: Photo) {
        
        self.photo = photo
        
        self.photoUrl = URL(string: photo.largeImageURL)
        
        let screenWidth = photo.size.width
        let screenHeight = photo.size.height
        
        print(screenWidth, screenHeight)
        
        photoImageView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //photoImageView.image = self.photo
        
        //photoImageView.kf.setImage(with: photoUrl)
        
        UIBlockingProgressHUD.show()
        photoImageView.kf.setImage(with: photoUrl) { result in
            switch result {
            case .success(_):
                
                UIBlockingProgressHUD.dismiss()
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func setupViews() {
        view.backgroundColor = Colors.ypBlack
        
        view.addSubview(scrollView)
        scrollView.addSubview(photoImageView)
        view.addSubview(shareButton)
        view.addSubview(backButton)
    }
    
    func setupConstraints() {
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        photoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
 
        //let screenWidth = UIScreen.main.bounds.width //photoImageView.image?.size.width ?? 0 //
        //let screenHeight = UIScreen.main.bounds.height //photoImageView.image?.size.height ?? 0  //
        
        
        photoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        photoImageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        
        shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -51).isActive = true
        shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        
    }
    
    //MARK: - Event Handler
    @objc func shareButtonTapped(_ sender: UIButton) {
        
        if let image = self.photoImageView.image {
            let share = UIActivityViewController(
                activityItems: [image],
                applicationActivities: nil
            )
            present(share, animated: true, completion: nil)
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}

