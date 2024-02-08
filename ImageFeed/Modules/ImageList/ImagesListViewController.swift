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
    
    //var fetchPhotosIsNotInProcess = false
    
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
        
        addObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchPhotosNextPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        removeObserver()
    }
    
}

//MARK: - Business Logic
extension ImagesListViewController {
    
    func fetchPhotosNextPage() {
        
        //если идёт закачка, то нового сетевого запроса не создаётся, а выполнение функции прерывается;
        //guard fetchPhotosIsNotInProcess == true else { return }
       
        //self.fetchPhotosIsNotInProcess = false
        
        imageListService.fetchPhotosNextPage { photos in
            
            self.photos += photos
            
            //ImagesListService.DidChangeNotification
            NotificationCenter.default                                     // 1
                .post(                                                     // 2
                    name: ImagesListService.DidChangeNotification,       // 3
                    object: self,                                          // 4
                    userInfo: ["photos": photos])
            
            //self.fetchPhotosIsNotInProcess = true
        }
        
    }
}

//MARK: - Observer

extension ImagesListViewController {
    
    
    
    private func addObserver() {
        NotificationCenter.default.addObserver(                 // 1
            self,                                               // 2
            selector: #selector(updateTableViewAnimated(notification:)),   // 3
            name: ImagesListService.DidChangeNotification,    // 4
            object: nil)                                        // 5
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(              // 6
            self,                                               // 7
            name: ImagesListService.DidChangeNotification,    // 8
            object: nil)                                        // 9
    }
    
    @objc                                                       // 10
    private func updateTableViewAnimated(notification: Notification) {     // 11
        guard
            isViewLoaded,                                       // 12
            let userInfo = notification.userInfo,               // 13
            let photos = userInfo["photos"] as? [Photo]   // 14
                
        else { return }

        self.tableView.reloadData()
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
        
        if indexPath.row + 1 == photos.count {
            print("will display ->", #line)
            fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FotoCell.reused, for: indexPath) as! FotoCell
        
        let photo = photos[indexPath.row]
        
        cell.backgroundColor = Colors.ypBlack
        cell.update(photo)
        
        cell.setIsLiked(!photo.isLiked)
        
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
        
        singleImageController.update(photo)
        
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



