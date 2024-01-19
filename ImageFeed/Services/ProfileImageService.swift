//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Artur Igberdin on 16.01.2024.
//

import Foundation

// MARK: - UserResult
struct UserResult: Codable {
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String
}

final class ProfileImageService {
    
    private (set) var avatarURL: String?
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    static let shared = ProfileImageService()
    let session = URLSession.shared
    let decoder = JSONDecoder.init()
    let token = OAuth2TokenStorage().token
    
    private init() {}
    
 
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        //1. URL
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/users/\(username)"
        
//        urlComponents.queryItems = [
//            URLQueryItem(name: "username", value: username),
//        ]
        
        guard let url = urlComponents.url else { return }
        print("image url ->", url)
        
        //2. Request
        
        var request = URLRequest.init(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("image request ->", request)
        
        request.debug()
        
        //3 Send Request
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            print("image json ->", data.prettyPrintedJSONString)
            
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    print("Success Status: \(response.statusCode)")
                    break
                default:
                    print("Status: \(response.statusCode)")
                }
            }
            
            
            do {
                print(Thread.current) //UI крутится на main-потоке (1-поток)
                let userResult = try self.decoder.decode(UserResult.self, from: data)
                
                DispatchQueue.main.async {
                    print(Thread.current) //Переключаемся на 1-поток
                    
                    //let profile = self.convert(profileResult)
                    //self.profile = profile
                    let avatarURL = userResult.profileImage.small
                    self.avatarURL = userResult.profileImage.small
                    
                    completion(.success(avatarURL))
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
}

fileprivate extension URLRequest {
    func debug() {
        print("\(self.httpMethod!) \(self.url!)")
        print("Headers:")
        print(self.allHTTPHeaderFields!)
        print("Body:")
        print(String(data: self.httpBody ?? Data(), encoding: .utf8)!)
    }
}
