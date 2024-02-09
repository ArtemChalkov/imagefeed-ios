//
//  ImagesListService.swift
//  ImageFeed
//
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage(completion: @escaping ([Photo])->())
}

final class ImagesListService: ImagesListServiceProtocol {
    
    let session = URLSession.shared
    let decoder = JSONDecoder.init()
    let token = OAuth2TokenStorage().token
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImageListProviderDidChange")
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage(completion: @escaping ([Photo])->()) {
        
        if task != nil {
            print("return ->", #function)
            return
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        lastLoadedPage = nextPage
        
        print(lastLoadedPage)
        
        //1. URL + Parameters
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "order_by", value: "popular"),
        ]
        guard let url = urlComponents.url else { return }
        
        //2. Request
        var request = URLRequest.init(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        //3. Call
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            print("->->", data.prettyPrintedJSONString)
            
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        
            do {
                print(Thread.current) //UI крутится на main-потоке (1-поток)
                let photosResult = try self.decoder.decode([PhotoResult].self, from: data)
                
                let photos: [Photo] = self.convert(photosResult: photosResult)
                
                DispatchQueue.main.async {
                    print(Thread.current) //Переключаемся на 1-поток
                    
                    self.photos = photos
                    print("->", photos)
                    
                    self.task = nil
                    
                    completion(photos)
                }
            } catch {
                print(error)
            }
        }
        self.task = task
        task.resume()
    }
    
    //Networking Model -> Presentation Model
    func convert(photosResult: [PhotoResult]) -> [Photo] {

        let isoDateFormatter = DateFormatter.iso6601Formatter
        
        var photos: [Photo] = []
        for item in photosResult {
            
            let thumbUrl = item.urls.thumb
            let largeUrl = item.urls.full
            
            let photo = Photo(id: item.id,
                              size: CGSize(width: item.width, height: item.height),
                              createdAt: isoDateFormatter.date(from: item.updatedAt ?? ""),
                              welcomeDescription: item.description,
                              thumbImageURL: thumbUrl,
                              largeImageURL: largeUrl,
                              isLiked: item.likedByUser)
            photos.append(photo)
        }
        
        return photos
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        //POST /photos/:id/like
        
        //1. URL + Parameters
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos/\(photoId)/like"
        guard let url = urlComponents.url else { return }
        
        //2. Request
        var request = URLRequest.init(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            print("like ->", data.prettyPrintedJSONString)
            
            DispatchQueue.main.async {
                completion(.success(()))
            }
            
           
        }
        task.resume()
        
    }
}
