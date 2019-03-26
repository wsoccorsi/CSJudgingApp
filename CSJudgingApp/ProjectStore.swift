import Foundation

enum ProjectsResult {
    case Success([Project])
    case Failure(Error)
}

class ProjectStore {
    
    var Projects: [Project] = []
    
    init() {
    }
    
    //=====================================================================
    
    private let session: URLSession = {
        
        let config = URLSessionConfiguration.default
        
        return URLSession(configuration: config)
    }()
    
    //=====================================================================
    
    //======
    //==05==
    //======
    private func ProcessRequest(data: Data?, error: Error?) -> ProjectsResult {
        
        guard
            let json = data
            else {
                return .Failure(error!)
        }
        
        //======  //======
        //==06==  //==09==
        //======  //======
        return WebAPI.ExtractProjects(from: json)
    }
    
    //=====================================================================
    
    //======
    //==03==
    //======
    func FetchAllProjectsFromWeb(completion: @escaping (ProjectsResult) -> Void) {
        
        let url = WebAPI.allProjectsURL
        
        let apiKey = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9jcy1qdWRnZS53My51dm0uZWR1XC9hcHAiLCJpYXQiOjE1NTM2MTQ1MzAsIm5iZiI6MTU1MzYxNDUzMCwiZXhwIjoxNTU0MjE5MzMwLCJkYXRhIjp7InVzZXIiOnsiaWQiOiIxMCJ9fX0.tXU9xChEZdCo9gT5c0BdWN_Ufen0JnyV2kxMxIszpYc"
        
        var request = URLRequest(url: url)
        
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler:
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
    }
    
    //=====================================================================
    
}
