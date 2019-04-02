import Foundation

func ExtractProjects(from data: Data) -> ProjectsResult {
    
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
            let Id = Proj["id"]! as? Int
            let Cat = Proj["category"]! as? String
            
            let NewProject = Project(name: Name!, id: Id!, cat: Cat!)
            
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

func ExtractToken(from data: Data) -> TokenResult {
    
    do
    {
        let JSONObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard
            let JSONDictionary = JSONObject as? [AnyHashable:Any],
            let Token = JSONDictionary["token"] as? String//,
            else
        {
            print("Here")
            return .Failure(WebError.InvalidJSON)
        }
        
        return .Success(Token)
    }
    catch let Error
    {
        return .Failure(Error)
    }
}
