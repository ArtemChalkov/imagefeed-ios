//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артем Чалков on 06.11.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    private let imagesList = Array(0...20)
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FotoCell.self, forCellReuseIdentifier: FotoCell.reused)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
   
}

//MARK: - Layout
extension ImagesListViewController {
    func setupViews() {
        view.backgroundColor = Colors.ypBlack
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
    }
}

extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        
        return imagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FotoCell.reused, for: indexPath) as! FotoCell
        
        let imageName = imagesList[indexPath.row]
        
        cell.update("\(imageName)")
        
        if indexPath.row % 2 == 0 {
            cell.likeButton.isSelected = true
        } else {
            cell.likeButton.isSelected = false
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let imageIndex = imagesList[indexPath.row]
        guard let image = UIImage(named: "\(imageIndex)") else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }

    
    
    
}



