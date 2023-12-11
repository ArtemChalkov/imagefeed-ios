//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Артем Чалков on 04.12.2023.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var photo: UIImage?
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = Colors.ypWhite
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
       
        //imageView.image = UIImage(named: "SingleImage")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
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
    
    func update(_ photo: UIImage) {
        self.photo = photo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.ypWhite
        
        photoImageView.image = self.photo
        
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoImageView.image = self.photo
    }
    
    func setupViews() {
        view.backgroundColor = Colors.ypBlack
        view.addSubview(scrollView)
        scrollView.addSubview(photoImageView)
        view.addSubview(shareButton)
    }
    
    func setupConstraints() {
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        photoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        photoImageView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -51).isActive = true
        shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        
        let image = UIImage(named: "1")
        
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

