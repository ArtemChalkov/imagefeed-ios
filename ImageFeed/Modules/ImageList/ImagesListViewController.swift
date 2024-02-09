//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артем Чалков on 06.11.2023.
//

import UIKit
protocol ImagesListViewControllerProtocol: AnyObject {
    
    var presenter: ImageListPresenterProtocol? { get set }
    
    //Update View
    func reloadTableView()
    
    func hideNavBar()
    
    func showNavBar()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    var presenter: ImageListPresenterProtocol?
    
    func reloadTableView() {
        tableView.reloadData()
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
        
        addObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        presenter?.viewDidAppear()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear()
    }
    
    func hideNavBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    deinit {
        removeObserver()
    }
}

//MARK: - Business Logic
extension ImagesListViewController {
    
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
        
        let photos: [Photo] = presenter?.getPhotos() ?? []
        
        if indexPath.row + 1 == photos.count {
            print("will display ->", #line)
            presenter?.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let photos: [Photo] = presenter?.getPhotos() ?? []
        return photos.count
    }
    
    func likeButtonTapped(_ photoId: String) {
        
        let photos: [Photo] = presenter?.getPhotos() ?? []
        
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            
            let photo = photos[index]
            
            let isLike = !photo.isLiked
            
            UIBlockingProgressHUD.show()
            
            presenter?.imageListService.changeLike(photoId: photoId, isLike: isLike) { result in
                
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
                
                presenter?.update(index, newPhoto: newPhoto)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FotoCell.reused, for: indexPath) as! FotoCell
        
        let photos: [Photo] = presenter?.getPhotos() ?? []
        
        let photo = photos[indexPath.row]
        
        cell.backgroundColor = Colors.ypBlack
        cell.update(photo)
        
        cell.setIsLiked(photo.isLiked)
        
        cell.onLikeButtonTapped = { [weak self] photoId in
            guard let self else { return }
            self.likeButtonTapped(photoId)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let photos: [Photo] = presenter?.getPhotos() ?? []
        
        let photo = photos[indexPath.row]
        let singleImageController = SingleImageViewController()
        
        singleImageController.modalPresentationStyle = .fullScreen
        present(singleImageController, animated: true)
        
        singleImageController.photoUrl = URL(string: photo.largeImageURL)//= UIImage(named: photo.largeImageURL)
        
        singleImageController.update(photo)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let photos: [Photo] = presenter?.getPhotos() ?? []
        
        let photo = photos[indexPath.row]
 
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        print("cell height ->",cellHeight)
        return cellHeight
    }
}



