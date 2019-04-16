//
//  HomeScreenStore.swift
//  CSJudgingApp
//
//  Created by Jason Campbell on 3/26/19.
//  Copyright © 2019 William  Soccorsi. All rights reserved.
//

import Foundation

enum HomeScreenStoreResult {
    case Success(HomeScreen)
    case Failure(Error)
}

class HomeScreenStore {
    var HomeScreenStore: HomeScreen
    init(HomeScreenStore: HomeScreen) {
        self.HomeScreenStore = HomeScreenStore
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
    private func ProcessRequest(data: Data?, error: Error?) -> HomeScreenStoreResult {
        
        guard
            let json = data
            else {
                return .Failure(error!)
        }
        
        //======  //======
        //==06==  //==09==
        //======  //======
        return WebAPI.ExtractHomeScreen(from: json)
    }
    
    //=====================================================================
    
    //======
    //==03==
    //======
    func FetchAllProjectsFromWeb(completion: @escaping (HomeScreenStoreResult) -> Void) {
        
        let url = WebAPI.homePageURL
        
        let apiKey = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9jcy1qdWRnZS53My51dm0uZWR1XC9hcHAiLCJpYXQiOjE1NTQ5OTYxODIsIm5iZiI6MTU1NDk5NjE4MiwiZXhwIjoxNTU1NjAwOTgyLCJkYXRhIjp7InVzZXIiOnsiaWQiOiI3In19fQ.4zuHh2lwCUzYs71Q2YR0cFWygrEzAcS1hN75QaUHfGs"
        
        var request = URLRequest(url: url)
        
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler:
        {
            (data, response, error) -> Void in
            
            //======
            //==04==
            //cs-judge.w3.uvm.edu/app/wp-json/cs-judge/v1/fairs/current
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
