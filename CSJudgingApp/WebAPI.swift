import Foundation

enum WebError: Error {
    case InvalidJSON
}

enum EndPoint: String {
    case allProjects = "cs-judge/v1/projects/year/2018"
    case  myProjects = "cs-judge/v1/users/my-judging-projects/current"
    case    homePage = "cs-judge/v1/fairs/current"
}

enum TokenResult {
    case Success(String)
    case Failure(Error)
}

class WebAPI {
    
    //=====================================================================
    
    var Data: CoreData!
    
    var isLoggedIn: Bool = false
    
    var Username: String? = nil
    var Password: String? = nil
    
    var BearerToken: String? = nil
    
    var LogInSuccessful: Bool = false
    
    private var BaseURL = "http://cs-judge.w3.uvm.edu/app/wp-json/"
    
    var allProjectsURL: URL {
        return CreateURL(endpoint: .allProjects, parameters: nil)
    }
    
    var myProjectsURL: URL {
        return CreateURL(endpoint: .myProjects, parameters: nil)
    }
    var homePageURL: URL{
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
    
    public func LogIn(username: String, password: String) -> Bool
    {
        Username = username
        Password = password
        
        var components = URLComponents(string: "http://cs-judge.w3.uvm.edu/app/wp-json/jwt-auth/v1/token")!
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "username", value: Username))
        queryItems.append(URLQueryItem(name: "password", value: Password))
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request, completionHandler:
        {
            (data, response, error) -> Void in

            if let HTTPResponse = response as? HTTPURLResponse
            {
                if(HTTPResponse.statusCode != 200)
                {
                    self.LogInSuccessful = false
                }
                else
                {
                    self.LogInSuccessful = true
                }
            }
            
            if (self.LogInSuccessful)
            {
                let result = self.ProcessTokenRequest(data: data, error: error)
            
                OperationQueue.main.addOperation
                {
                        switch result
                        {
                            case let .Success(token):
                            
                                self.BearerToken = token
                            
                                self.Data.updateEntity(Username: self.Username!, Password: self.Password!, Token: token, Date: Date())
                            
                            case let .Failure(error):
                                print("Error Getting Token: \(error)")
                        }
                }
            }
        })
        
        task.resume()
        
        print(LogInSuccessful)
        return LogInSuccessful
    }
    
    //=====================================================================
    //=====================================================================
    
    private func ProcessTokenRequest(data: Data?, error: Error?) -> TokenResult {
        
        guard
            let json = data
            else
        {
            return .Failure(error!)
        }
        
        return ExtractToken(from: json)
    }
    
    //=====================================================================
    
    private func ProcessRequest(data: Data?, error: Error?) -> ProjectsResult {
        
        guard
            let json = data
            else {
                return .Failure(error!)
        }
        
        return ExtractProjects(from: json)
    }
    
    private func ProcessSingleRequest(data: Data?, error: Error?) -> ProjectsResult {
        
        guard
            let json = data
            else {
                return .Failure(error!)
        }
        
        return ExtractProject(from: json)
    }
    //=====================================================================
    
    private func ProcessHomeScreenRequest(data: Data?, error: Error?) -> HomeScreenResult {
        
        guard
            let json = data
            else {
                return .Failure(error!)
        }
        
        return ExtractHomeScreen(from: json)
    }
    
    //=====================================================================
    //=====================================================================
    
    func FetchAllProjectsFromWeb(completion: @escaping (ProjectsResult) -> Void) {
        
        if(BearerToken != nil)
        {
            
            let url = allProjectsURL
            
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
        else
        {
            print("FetchAllProjectsFromWeb: No Bearer Token")
        }
    }
    
    //=====================================================================
    
    func FetchMyProjectsFromWeb(completion: @escaping (ProjectsResult) -> Void) {
        
        if(BearerToken != nil)
        {
            
            let url = myProjectsURL
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
        else
        {
            print("FetchMyProjectsFromWeb: No Bearer Token")
        }
    }
    //---------------------------------------------------------------------
    //---------------------------------------------------------------------
    func GetQRProject(completion: @escaping (ProjectsResult) -> Void ,link:String) {
        
        if(BearerToken != nil)
        {
            let components = URLComponents(string: link)!
            
            let url = components.url!
            var request = URLRequest(url: url)
            
            request.addValue("Bearer " + self.BearerToken!, forHTTPHeaderField: "Authorization")
            
            let task = self.session.dataTask(with: request, completionHandler:
            {
                (data, response, error) -> Void in
                let result = self.ProcessSingleRequest(data: data, error: error)
                
                OperationQueue.main.addOperation
                    {
                        
                        completion(result)
                }
            })
            
            task.resume()
        }
        else
        {
            print("FetchMyProjectsFromWeb: No Bearer Token")
        }
    }
    //=====================================================================
    
    func FetchHomeScreenFromWeb(completion: @escaping (HomeScreenResult) -> Void) {
        
        if(BearerToken != nil)
        {
            
            let url = homePageURL
            
            var request = URLRequest(url: url)
            
            request.addValue("Bearer " + self.BearerToken!, forHTTPHeaderField: "Authorization")
            
            let task = self.session.dataTask(with: request, completionHandler:
            {
                (data, response, error) -> Void in
                
                let result = self.ProcessHomeScreenRequest(data: data, error: error)
                
                OperationQueue.main.addOperation
                    {
                        
                        completion(result)
                }
            })
            
            task.resume()
        }
        else
        {
            print("FetchHomeScreenFromWeb: No Bearer Token")
        }
    }
    
}
