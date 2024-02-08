
import Foundation

struct Profile: Codable {
    
    var username: String // — логин пользователя в том же виде, в каком мы получаем его от сервиса,
    var name: String // — конкатенация имени и фамилии пользователя (если first_name = "Ivan", last_name = "Ivanov", то name = "Ivan Ivanov"),
    var loginName: String  //— username со знаком @ перед первым символом (если username = "ivanivanov", то loginName = "@ivanivanov"),
    var bio: String  //совпадает с bio из ProfileResult.
    
}

protocol ProfileServiceProtocol: AnyObject {
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
    
    var profile: Profile? { get }
}

final class ProfileService: ProfileServiceProtocol {
    
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    let session = URLSession.shared
    let decoder = JSONDecoder.init()
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
    //https://api.unsplash.com/me
        
        //1. URL
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/me"
        
        guard let url = urlComponents.url else { return }
        
        //2. Request
        
        var request = URLRequest.init(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        //3. Call
        let task = session.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
            }
            
            print("json ->", data?.prettyPrintedJSONString)
            
            if let error = error {
                print(error.localizedDescription)
                print("thread ->", Thread.current)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            print("json ->", data.prettyPrintedJSONString)
            
            do {
                print(Thread.current) //UI крутится на main-потоке (1-поток)
                let profileResult = try self.decoder.decode(ProfileResult.self, from: data)
                
                DispatchQueue.main.async {
                    print(Thread.current) //Переключаемся на 1-поток
                    
                    let profile = self.convert(profileResult)
                    self.profile = profile
                    
                    completion(.success(profile))
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    //ProfileResult -> Profile.
    func convert(_ result: ProfileResult) -> Profile {
 
        let firstName = result.firstName ?? ""
        let lastName = result.lastName ?? ""
        let fullName = firstName + " " + lastName
        
        var profile = Profile.init(username: result.username ?? "",
                                   name: fullName,
                                   loginName: result.email ?? "",
                                   bio: result.bio ?? "")
        
        return profile
    }
    
}
