import Foundation

enum WebError: Error {
    case InvalidJSON
}

enum EndPoint: String {
    case allProjects = "cs-judge/v1/projects/year/2018"
    case  myProjects = "cs-judge/v1/users/my-judging-projects/current"
}

enum TokenResult {
    case Success(String)
    case Failure(Error)
}

class WebAPI {
    
    //=====================================================================
    //    var Username: String? = nil
    //    var Password: String? = nil
    var Username: String? = "william.slocum@uvm.edu"
    var Password: String? = "Smrrvjt5"
    
    var BearerToken: String? = nil
    
    private var BaseURL = "http://cs-judge.w3.uvm.edu/app/wp-json/"
    
    var allProjectsURL: URL {
        return CreateURL(endpoint: .allProjects, parameters: nil)
    }
    
    var myProjectsURL: URL {
        return CreateURL(endpoint: .myProjects, parameters: nil)
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
        //cs-judge.w3.uvm.edu/jwt-auth/v1/token?Username=william.slocum@uvm.edu&Password=Smrrvjt5
        
        var components = URLComponents(string: "http://cs-judge.w3.uvm.edu/app/wp-json/jwt-auth/v1/token")!
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "username", value: username!))
        queryItems.append(URLQueryItem(name: "password", value: password!))
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        
        print("Pre Task")
        let task = session.dataTask(with: request, completionHandler:
        {
            (data, response, error) -> Void in
            
            print("Completion")
            let result = self.ProcessTokenRequest(data: data, error: error)
            
            OperationQueue.main.addOperation
                {
                    print("Operation")
                    switch result
                    {
                    case let .Success(token):
                        self.BearerToken = token
                        completion()
                        
                    case let .Failure(error):
                        print("Error Fetching Projects: \(error)")
                    }
            }
            
            //completion()
        })
        
        task.resume()
    }
    
    //======
    //==07==
    //======
    //    func ExtractProjects(from data: Data) -> ProjectsResult {
    //
    //        do
    //        {
    //            let JSONObject = try JSONSerialization.jsonObject(with: data, options: [])
    //
    //            guard
    //                let JSONDictionary = JSONObject as? [AnyHashable:Any],
    //                let ProjectList = JSONDictionary["projects"] as? [[AnyHashable:Any]]//,
    //                else
    //            {
    //                return .Failure(WebError.InvalidJSON)
    //            }
    //
    //            var ProjectsReturn: [Project] = []
    //
    //            for Proj in ProjectList
    //            {
    //                let Name = Proj["name"]! as? String
    //                let Id = Proj["id"]! as? Int
    //                let Cat = Proj["category"]! as? String
    //
    //                let NewProject = Project(name: Name!, id: Id!, cat: Cat!)
    //
    //                ProjectsReturn.append(NewProject)
    //            }
    //
    //            //======
    //            //==08==
    //            //======
    //            return .Success(ProjectsReturn)
    //        }
    //        catch let Error
    //        {
    //            return .Failure(Error)
    //        }
    //    }
    
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
    
    private func ProcessRequest(data: Data?, error: Error?) -> ProjectsResult {
        
        guard
            let json = data
            else {
                return .Failure(error!)
        }
        
        //======  //======
        //==06==  //==09==
        //======  //======
        return ExtractProjects(from: json)
    }
    
    //=====================================================================
    
    //======
    //==03==
    //======
    func FetchAllProjectsFromWeb(completion: @escaping (ProjectsResult) -> Void) {
        
        //let url = WebAPI.allProjectsURL
        let url = allProjectsURL
        
        //        let apiKey = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9jcy1qdWRnZS53My51dm0uZWR1XC9hcHAiLCJpYXQiOjE1NTM2MTQ1MzAsIm5iZiI6MTU1MzYxNDUzMCwiZXhwIjoxNTU0MjE5MzMwLCJkYXRhIjp7InVzZXIiOnsiaWQiOiIxMCJ9fX0.tXU9xChEZdCo9gT5c0BdWN_Ufen0JnyV2kxMxIszpYc"
        
        GetBearerToken(username: Username, password: Password, completion:
            {
                var request = URLRequest(url: url)
                
                request.addValue("Bearer " + self.BearerToken!, forHTTPHeaderField: "Authorization")
                
                let task = self.session.dataTask(with: request, completionHandler:
                {
                    (data, response, error) -> Void in
                    
                    //======
                    //==04==
                    //======
                    let result = self.ProcessRequest(data: data, error: error)
                    
                    OperationQueue.main.addOperation
                        {
                            //======
                            //==10==
                            //======
                            completion(result)
                    }
                })
                
                task.resume()
        })
    }
}
