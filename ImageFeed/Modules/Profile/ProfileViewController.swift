//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Артем Чалков on 04.12.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Profile")
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var exitButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        return button
    }()
    
    var profileNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = Colors.ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.clipsToBounds = false
        label.text = "Екатерина Новикова"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nikNameLabel: UILabel = {
        var label = UILabel()
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
        //photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -289).isActive = true
       
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 89).isActive = true
        //exitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 315).isActive = true
        exitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        profileNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8).isActive = true
        profileNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        //profileNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -118).isActive = true
       
        nikNameLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8).isActive = true
        nikNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        //nikNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -260).isActive = true
       
        statusLabel.topAnchor.constraint(equalTo: nikNameLabel.bottomAnchor, constant: 8).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        //statusLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -282).isActive = true
    }
    
    
}
