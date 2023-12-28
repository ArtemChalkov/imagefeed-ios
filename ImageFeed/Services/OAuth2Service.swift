//
//  OAuth2Service.swift
//  ImageFeed
//


import Foundation

//Feature Request (токен в хедерах)
//Authorization: Bearer ACCESS_TOKEN

protocol OAuth2ServiceProtocol {
    func fetchAuthToken(code: String, completion: @escaping (Swift.Result<String, Error>)->())
}

class OAuth2Service: OAuth2ServiceProtocol {
    
    let decoder = JSONDecoder.init()
    
    func fetchAuthToken(code: String, completion: @escaping (Swift.Result<String, Error>)->()) {
     
        //1. Cобрать URL
        //Percent Encoding, ASCII,
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "unsplash.com"
        urlComponents.path = "/oauth/token"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let url = urlComponents.url else { return }
        
        //2. Сконфигурировать запрос (URL + HTTP METHOD + HEADERS + BODY)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //3. Создать сессию и запустить запрос
        
        var session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    print("Success Status: \(response.statusCode)")
                    break
                default:
                    print("Status: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return }
            
            print("data ->", String(data: data, encoding: .utf8)) 
           
            do {
                print(Thread.current) //UI крутится на main-потоке (1-поток)
                let response = try self.decoder.decode(AccessToken.self, from: data)
                
                DispatchQueue.main.async {
                    print(Thread.current) //Переключаемся на 1-поток
                   
                    completion(Result.success(response.accessToken))
                }
            } catch {
                print(error)
                
                completion(.failure(error))
            }
            
            
        }
        task.resume()
        
        
            //https://unsplash.com/oauth/token
        
        //client_id    Your application’s access key.
        //client_secret    Your application’s secret key.
        //redirect_uri    Your application’s redirect URI.
        //code    The authorization code supplied to the callback by Unsplash.
        //grant_type    Value “authorization_code”.
      
        //Response

        
    }
}
