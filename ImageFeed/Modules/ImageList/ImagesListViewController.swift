//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артем Чалков on 06.11.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    private let imageListService = ImagesListService()
    
    private var photos: [Photo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init()
        tableView.backgroundColor = Colors.ypBlack
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FotoCell.self, forCellReuseIdentifier: FotoCell.reused)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        imageListService.fetchPhotosNextPage { photos in
            
            self.photos = photos
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

//MARK: - Layout
extension ImagesListViewController {
    func setupViews() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //if indexPath.row + 1 == photos.count {
        
        
        //}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FotoCell.reused, for: indexPath) as! FotoCell
        
        let photo = photos[indexPath.row]
        
        cell.backgroundColor = Colors.ypBlack
        cell.update(photo)
        
        cell.onLikeButtonTapped = { photoId in
            
            
            
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                
                let photo = self.photos[index]
                
                let isLike = !photo.isLiked
                
                UIBlockingProgressHUD.show()
                self.imageListService.changeLike(photoId: photoId, isLike: isLike) { result in
                    
                    switch result {
                    case .success():
                        
                        
                        changeToNewPhoto(photo)
                        UIBlockingProgressHUD.dismiss()
                    case .failure(let error):
                        print(error)
                        UIBlockingProgressHUD.dismiss()
                    }
                }
                
                
                func changeToNewPhoto(_ photo: Photo) {
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    // Заменяем элемент в массиве.
                    //self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                    
                    self.photos[index] = newPhoto
                }
                
                
                
            }
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let photo = photos[indexPath.row]
        //let photoImage = UIImage(named: photo.thumbImageURL)
        let singleImageController = SingleImageViewController()
        
        singleImageController.modalPresentationStyle = .fullScreen
        present(singleImageController, animated: true)
        
        singleImageController.photoUrl = URL(string: photo.largeImageURL)//= UIImage(named: photo.largeImageURL)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let photo = photos[indexPath.row]
        //        guard let image = UIImage(named: photo.thumbImageURL) else {
        //            return 0
        //        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        print("cell height ->",cellHeight)
        return cellHeight
    }
}



