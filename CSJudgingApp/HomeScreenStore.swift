////
////  HomeScreenStore.swift
////  CSJudgingApp
////
////  Created by Jason Campbell on 3/26/19.
////  Copyright © 2019 William  Soccorsi. All rights reserved.
////
//
//import Foundation
//
////enum HomeScreenStoreResult {
////    case Success(HomeScreen)
////    case Failure(Error)
////}
//
//class HomeScreenStore {
//    var HomeScreenStore: HomeScreen
//    init(HomeScreenStore: HomeScreen) {
//        self.HomeScreenStore = HomeScreenStore
//    }
//    
//    
//    
//    //=====================================================================
//    
//    private let session: URLSession = {
//        
//        let config = URLSessionConfiguration.default
//        
//        return URLSession(configuration: config)
//    }()
//    
//    //=====================================================================
//    
//    //======
//    //==05==
//    //======
//    private func ProcessRequest(data: Data?, error: Error?) -> HomeScreenStoreResult {
//        
//        guard
//            let json = data
//            else {
//                return .Failure(error!)
//        }
//        
//        //======  //======
//        //==06==  //==09==
//        //======  //======
//        return WebAPI.ExtractHomeScreen(from: json)
//    }
//    
//    //=====================================================================
//    
//    //======
//    //==03==
//    //======
//        
//    //=====================================================================
//    
//}
