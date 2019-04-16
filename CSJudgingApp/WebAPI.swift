import Foundation

enum WebError: Error {
    case InvalidJSON
}

enum EndPoint: String {
    case allProjects = "cs-judge/v1/projects/year/2018"
    case  myProjects = "cs-judge/v1/users/my-judging-projects/current"
    case homePage = "cs-judge/v1/fairs/current"
}

enum TokenResult {
    case Success(String)
    case Failure(Error)
}

class WebAPI {
    
    //=====================================================================
    
    var Username: String? = "william.slocum@uvm.edu"
    var Password: String? = "Password12345Password"
    
    var BearerToken: String? = nil
    
    private var BaseURL = "http://cs-judge.w3.uvm.edu/app/wp-json/"
    
    var allProjectsURL: URL {
        return CreateURL(endpoint: .allProjects, parameters: nil)
    }
    
    var myProjectsURL: URL {
        return CreateURL(endpoint: .myProjects, parameters: nil)
    }
    static var homePageURL: URL{
        return CreateURL(endpoint: .homePage, parameters: nil)
    }
    
    //=====================================================================
    
    private func CreateURL(endpoint: EndPoint, parameters: [String:String]?) -> URL {
        
        let url = BaseURL + endpoint.rawValue
        
        let components = URLComponents(string: url)!
        
        return components.url!
    }
    
    //=====================================================================
    
    private let session: URLSession = {
        
        let config = URLSessionConfiguration.default
        
        return URLSession(configuration: config)
    }()
    
    //=====================================================================
    
    private func GetBearerToken(username: String?, password: String?, completion: @escaping () -> Void) -> Void
    {
        var components = URLComponents(string: "http://cs-judge.w3.uvm.edu/app/wp-json/jwt-auth/v1/token")!
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "username", value: username!))
        queryItems.append(URLQueryItem(name: "password", value: password!))
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request, completionHandler:
        {
            (data, response, error) -> Void in
            
            let result = self.ProcessTokenRequest(data: data, error: error)
            
            OperationQueue.main.addOperation
            {
                switch result
                {
                    case let .Success(token):
                        self.BearerToken = token
                        completion()
                    
                    case let .Failure(error):
                        print("Error Fetching Projects: \(error)")
                }
            }
        })
        
        task.resume()
    }
    
    private func ProcessTokenRequest(data: Data?, error: Error?) -> TokenResult {
        
        guard
            let json = data
            else
        {
            return .Failure(error!)
        }
        
        return ExtractToken(from: json)
    }
    
    private func ProcessRequest(data: Data?, error: Error?) -> ProjectsResult {
        
        guard
            let json = data
            else {
                return .Failure(error!)
        }
        
        return ExtractProjects(from: json)
    }
    
    //=====================================================================
    
    func FetchAllProjectsFromWeb(completion: @escaping (ProjectsResult) -> Void) {
        
        let url = allProjectsURL
        
        if (BearerToken == nil)
        {
            GetBearerToken(username: Username, password: Password, completion:
                {
                    var request = URLRequest(url: url)
                    
                    request.addValue("Bearer " + self.BearerToken!, forHTTPHeaderField: "Authorization")
                    
                    let task = self.session.dataTask(with: request, completionHandler:
                    {
                        (data, response, error) -> Void in
                        
                        let result = self.ProcessRequest(data: data, error: error)
                        
                        OperationQueue.main.addOperation
                            {
                                
                                completion(result)
                        }
                    })
                    
                    task.resume()
            })
        }
        else
        {
            var request = URLRequest(url: url)
            
            request.addValue("Bearer " + self.BearerToken!, forHTTPHeaderField: "Authorization")
            
            let task = self.session.dataTask(with: request, completionHandler:
            {
                (data, response, error) -> Void in
                
                let result = self.ProcessRequest(data: data, error: error)
                
                OperationQueue.main.addOperation
                    {
                        
                        completion(result)
                }
            })
            
            task.resume()
        }
    }
    
    func FetchMyProjectsFromWeb(completion: @escaping (ProjectsResult) -> Void) {
        
        let url = myProjectsURL
        
        if (BearerToken == nil)
        {
            GetBearerToken(username: Username, password: Password, completion:
            {
                    var request = URLRequest(url: url)
                
                    request.addValue("Bearer " + self.BearerToken!, forHTTPHeaderField: "Authorization")
                
                    let task = self.session.dataTask(with: request, completionHandler:
                    {
                        (data, response, error) -> Void in
                        
                        let result = self.ProcessRequest(data: data, error: error)
                        
                        OperationQueue.main.addOperation
                            {
                                
                                completion(result)
                        }
                    })
                
                    task.resume()
            })
        }
        else
        {
            var request = URLRequest(url: url)
            
            request.addValue("Bearer " + self.BearerToken!, forHTTPHeaderField: "Authorization")
            
            let task = self.session.dataTask(with: request, completionHandler:
            {
                (data, response, error) -> Void in
                
                let result = self.ProcessRequest(data: data, error: error)
                
                OperationQueue.main.addOperation
                    {
                        
                        completion(result)
                }
            })
            
            task.resume()
        }
    }
    static func ExtractHomeScreen(from data: Data) -> HomeScreenStoreResult {
        
        do
        {
            
            
            let JSONObject = try JSONSerialization.jsonObject(with: data, options: [])
            // "http://cs-judge.w3.uvm.edu/app/wp-content/uploads/2018/10/CS_Fair-25.jpg"
            guard
                let JSONDictionary = JSONObject as? [AnyHashable:Any],
                
                let id = JSONDictionary["id"] as? Int,
                let Featured_img_url = JSONDictionary["featured_image_url"] as? String,
                let name = JSONDictionary["name"]  as? String,
                let Deescription = JSONDictionary["description"] as? String,
                let year = JSONDictionary["year"] as? String,
                let Is_current = JSONDictionary["is_current"] as? Bool,
                let Date = JSONDictionary["date"] as? String
                else
            {
                return .Failure(WebError.InvalidJSON)
            }
            let HomeScreenReturn = HomeScreen(id: id, name: name, deescription: Deescription, year: year, is_current: Is_current, featured_img_url: Featured_img_url, date: Date)
            
            
            
            
            
            return .Success(HomeScreenReturn)
        }
        catch let Error
        {
            return .Failure(Error)
        }
    }
}
