import Foundation

enum WebError: Error {
    case InvalidJSON
}

enum EndPoint: String {
    case allProjects = "cs-judge/v1/projects/year/2018"
}

struct WebAPI {
    
    //=====================================================================
    
    private static var BaseURL = "http://cs-judge.w3.uvm.edu/app/wp-json/"
    
    static var allProjectsURL: URL {
        return CreateURL(endpoint: .allProjects, parameters: nil)
    }
    
    //=====================================================================
    
    private static func CreateURL(endpoint: EndPoint, parameters: [String:String]?) -> URL {
        
        let url = BaseURL + endpoint.rawValue
        
        let components = URLComponents(string: url)!
        
        return components.url!
    }
    
    //=====================================================================
    
    //======
    //==07==
    //======
    static func ExtractProjects(from data: Data) -> ProjectsResult {
        
        do
        {
            let JSONObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let JSONDictionary = JSONObject as? [AnyHashable:Any],
                let ProjectList = JSONDictionary["projects"] as? [[AnyHashable:Any]]//,
                else
            {
                return .Failure(WebError.InvalidJSON)
            }
            
            var ProjectsReturn: [Project] = []
            
            for Proj in ProjectList
            {
                let Name = Proj["name"]! as? String
                let Desc = Proj["description"]! as? String
                let Cat = Proj["category"]! as? String
                let Id = Proj["id"]! as? Int
                let Booth = Proj["boothNumber"]! as? String
                let Course = Proj["courses"]! as? String
                let Time = Proj["time"]! as? String


                
                let NewProject = Project(title: Name!, id: Id!, desc: Desc!, category: Cat!,
                                         booth: Booth!, time: Time!)
                                        
                
                ProjectsReturn.append(NewProject)
            }
            
            //======
            //==08==
            //======
            return .Success(ProjectsReturn)
        }
        catch let Error
        {
            return .Failure(Error)
        }
    }
}
