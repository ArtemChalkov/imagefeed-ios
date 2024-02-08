//
//  File.swift
//  ImageFeed
//


import Foundation

protocol ImageListPresenterProtocol: AnyObject {
    
    //Dependencies
    var view: ImagesListViewControllerProtocol? { get set }
    
    //View Event
    func viewDidAppear()
    func viewWillAppear()
    func viewWillDisappear()

    //Business Logic
    func fetchPhotosNextPage()
    
    var imageListService: ImagesListService { get set }
    
    func getPhotos() -> [Photo]
    
    func update(_ index: Int, newPhoto: Photo)
        
}

class ImageListPresenter: ImageListPresenterProtocol {
    
    func viewDidAppear() {
        self.fetchPhotosNextPage()
    }
    
    
    weak var view: ImagesListViewControllerProtocol?
    
    var imageListService = ImagesListService()
    
    private var photos: [Photo] = [] {
        didSet {
            view?.reloadTableView()
        }
    }
    
    func update(_ index: Int, newPhoto: Photo) {
        self.photos[index] = newPhoto
    }
    
    func getPhotos() -> [Photo] {
        return photos
    }
    
    func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage { photos in
            
            self.photos += photos
            
            //ImagesListService.DidChangeNotification
            NotificationCenter.default                                     // 1
                .post(                                                     // 2
                    name: ImagesListService.DidChangeNotification,       // 3
                    object: nil,                                          // 4
                    userInfo: ["photos": photos])
        }
        
    }
    
    func viewWillAppear() {
        view?.hideNavBar()
    }
    
    func viewWillDisappear() {
        view?.showNavBar()
    }
}
