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
            let Desc = Proj["description"]! as? String
            let Booth = Proj["boothNumber"] as? String
            let Time = Proj["time"] as? String
            let Student = Proj["students"] as? String
            let Courses = Proj["courses"] as? String
            let Side = Proj["boothSide"] as? String
            
            let NewProject = Project(name: Name!, id: Id!, desc: Desc!, cat: Cat!, booth: Booth!, time: Time!, students: [Student!], courses: [Courses!], boothSide: Side!)
            
            ProjectsReturn.append(NewProject)
        }
        
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
                return .Failure(WebError.InvalidJSON)
            }
        
        return .Success(Token)
    }
    catch let Error
    {
        return .Failure(Error)
    }
}

func ExtractHomeScreen(from data: Data) -> HomeScreenResult {
    
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
    
    func ExtractProject(from data: Data) -> ProjectsResult {
        
        do
        {
//            let s = String(data: data, encoding: String.Encoding.utf8) as String!
//            print(s)
            let JSONObject = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
            print("\n\n\n\n\n\n\n\n22\n\n\n\n\n\\n")
            guard
                let Proj = JSONObject as? [AnyHashable:Any]
                else
            {
                return .Failure(WebError.InvalidJSON)
            }
                let Name = Proj["name"]! as? String
                let Id = Proj["id"]! as? Int
                let Cat = Proj["category"]! as? String
                let Desc = Proj["description"]! as? String
                let Booth = Proj["boothNumber"] as? String
                let Time = Proj["time"] as? String
                let Student = Proj["students"] as? String
                let Courses = Proj["courses"] as? String
                let Side = Proj["boothSide"] as? String
                
                let NewProject = Project(name: Name!, id: Id!, desc: Desc!, cat: Cat!, booth: Booth!, time: Time!, students: [Student!], courses: [Courses!], boothSide: Side!)
                
            
            
            print("\n\n\n\n\n\n\n\n0\n\n\n\n\n\\n")
            return .Success([NewProject])
        }
        catch let Error
        {
            print("\n\n\n\n\n\n\n\n1\n\n\n\n\n\\n")
            return .Failure(Error)
        }
    }
