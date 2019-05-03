import Foundation

func ExtractProjects(from data: Data) -> ProjectsResult {
    
    do
    {
        let JSONObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard
            let JSONDictionary = JSONObject as? [AnyHashable:Any],
            let ProjectList = JSONDictionary["projects"] as? [[AnyHashable:Any]]//,
            else {
                return .Failure(WebError.InvalidJSON)
            }
        
        var ProjectsReturn: [Project] = []
        
        for Proj in ProjectList
        {
            var Functionality = -1;
            var Design = -1;
            var Presentation = -1;
            let Name = Proj["name"]! as? String
            let Id = Proj["id"]! as? Int
            let Cat = Proj["category"]! as? String
            let Desc = Proj["description"]! as? String
            let Booth = Proj["boothNumber"] as? String
            let Time = Proj["time"] as? String
            let Student = Proj["students"] as? String
            let Courses = Proj["courses"] as? String
            let Side = Proj["boothSide"] as? String
            let Judge = Proj["judging_info"] as? [(Any)]
            let areJudge = Proj["current_user_judging"] as? Bool
            let hasJudged = Proj["has_judged"] as? Bool
            if (areJudge == true){
                var Criteria = Judge?[0] as? [AnyHashable:Any]
                var temp = Criteria?["judge_score"] as? String
                if let temp2 = temp {
                    Functionality = (temp2 as NSString).integerValue
                }
                Criteria = Judge?[1] as? [AnyHashable:Any]
                temp = Criteria?["judge_score"] as? String
                if let temp2 = temp {
                    Design = (temp2 as NSString).integerValue
                }
                Criteria = Judge?[2] as? [AnyHashable:Any]
                temp = Criteria?["judge_score"] as? String
                if let temp2 = temp {
                    Presentation = (temp2 as NSString).integerValue
                }

            }
            
            let NewProject = Project(name: Name!, id: Id!, desc: Desc!, cat: Cat!, booth: Booth!, time: Time!, students: [Student!], courses: [Courses!], boothSide: Side!, judgingInfo: Judge!, areJudged: areJudge!, hasJudged: hasJudged!, functionality: Functionality, design: Design, presentation: Presentation)
            
            ProjectsReturn.append(NewProject)
        }
        
        return .Success(ProjectsReturn)
    }
    catch let Error {
        return .Failure(Error)
    }
}

func ExtractToken(from data: Data) -> TokenResult {
    
    do {
        let JSONObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard
            let JSONDictionary = JSONObject as? [AnyHashable:Any],
            let Token = JSONDictionary["token"] as? String//,
            else {
                return .Failure(WebError.InvalidJSON)
            }
        
        return .Success(Token)
    }
    catch let Error {
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
            
            else {
                return .Failure(WebError.InvalidJSON)
            }
        
        let HomeScreenReturn = HomeScreen(id: id, name: name, deescription: Deescription, year: year, is_current: Is_current, featured_img_url: Featured_img_url, date: Date)
        
        return .Success(HomeScreenReturn)
    }
        
    catch let Error {
        return .Failure(Error)
    }
}
    
    func ExtractProject(from data: Data) -> ProjectsResult {
        
        do {
            let JSONObject = try JSONSerialization.jsonObject(with: data, options:.allowFragments)

            guard
                let Proj = JSONObject as? [AnyHashable:Any]
                else {
                    return .Failure(WebError.InvalidJSON)
                }
                var Functionality = -1;
                var Design = -1;
                var Presentation = -1;
                let Name = Proj["name"]! as? String
                let Id = Proj["id"]! as? Int
                let Cat = Proj["category"]! as? String
                let Desc = Proj["description"]! as? String
                let Booth = Proj["boothNumber"] as? String
                let Time = Proj["time"] as? String
                let Student = Proj["students"] as? String
                let Courses = Proj["courses"] as? String
                let Side = Proj["boothSide"] as? String
                let Judge = Proj["judging_info"] as? [(Any)]
                let areJudge = Proj["current_user_judging"] as? Bool
                let hasJudged = Proj["has_judged"] as? Bool
                if (areJudge == true)
                {
                    var Criteria = Judge?[0] as? [AnyHashable:Any]
                    var temp = Criteria?["judge_score"] as? String
                    if let temp2 = temp {
                        Functionality = (temp2 as NSString).integerValue
                    }
                    Criteria = Judge?[1] as? [AnyHashable:Any]
                    temp = Criteria?["judge_score"] as? String
                    if let temp2 = temp {
                        Design = (temp2 as NSString).integerValue
                    }
                    Criteria = Judge?[2] as? [AnyHashable:Any]
                    temp = Criteria?["judge_score"] as? String
                    if let temp2 = temp {
                        Presentation = (temp2 as NSString).integerValue
                    }
                }
            
            let NewProject = Project(name: Name!, id: Id!, desc: Desc!, cat: Cat!, booth: Booth!, time: Time!, students: [Student!], courses: [Courses!], boothSide: Side!, judgingInfo: Judge!, areJudged: areJudge!, hasJudged: hasJudged!, functionality: Functionality, design: Design, presentation: Presentation)
            
            return .Success([NewProject])
        }
        catch let Error {
            return .Failure(Error)
        }
    }
