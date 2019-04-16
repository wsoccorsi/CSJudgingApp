//
//  HomeScreenViewController.swift
//  CSJudgingApp
//
//  Created by Jason Campbell on 3/27/19.
//  Copyright © 2019 William  Soccorsi. All rights reserved.
//

import UIKit

class HomeScreenViewController : UIViewController {
    
    var HomeScreenStore2 : HomeScreenStore!
    var img : UIImage!
    @IBOutlet var imgView : UIImageView! //i
    @IBOutlet var name : UILabel!
    @IBOutlet var deeescription: UILabel!
    @IBOutlet var date : UILabel!
    
    override func viewDidLoad() {
        //        var HomeScreenStore99 : HomeScreenStore = HomeScreenStore(HomeScreenStore: HomeScreen)
        let HomeScreen5 = HomeScreen(id: 11, name: "" , deescription: "", year: "", is_current: true, featured_img_url: "", date: "")
        HomeScreenStore2 = HomeScreenStore(HomeScreenStore : HomeScreen5)
        HomeScreenStore2.HomeScreenStore.id = 11
        HomeScreenStore2.HomeScreenStore.featured_img_url = "HomeScreen.featured_img_url"
        //        HomeScreenStore2.HomeScreenStore.date = "HomeScreen.date"
        //        HomeScreenStore2.HomeScreenStore.name = "1HomeScreen.name"
        //        HomeScreenStore2.HomeScreenStore.deescription = "HomeScreen.deescription"
        //        HomeScreenStore2.HomeScreenStore.year = "HomeScreen.year"
        //        HomeScreenStore2.HomeScreenStore.is_current = true
        //        HomeScreenStore2.FetchAllProjectsFromWeb(completion: updateTableView)
        
        
        
        
        //img = UIImage(
        super.viewDidLoad()
        HomeScreenStore2.FetchAllProjectsFromWeb(completion: updateTableView)
        
    }
    func updateTableView(homeScreenResult: HomeScreenStoreResult) {
        
        
        //        name.text = HomeScreenStore2.HomeScreenStore.name
        
        switch homeScreenResult
        {
        case let .Success(HomeScreen):
            //            print(HomeScreen.id)
            HomeScreenStore2.HomeScreenStore.id = HomeScreen.id
            //            print(HomeScreenStore2.HomeScreenStore.id)
            HomeScreenStore2.HomeScreenStore.featured_img_url = HomeScreen.featured_img_url
            HomeScreenStore2.HomeScreenStore.date = HomeScreen.date
            HomeScreenStore2.HomeScreenStore.name = HomeScreen.name
            HomeScreenStore2.HomeScreenStore.deescription = HomeScreen.deescription
            HomeScreenStore2.HomeScreenStore.year = HomeScreen.year
            HomeScreenStore2.HomeScreenStore.is_current = HomeScreen.is_current
            
            let image_url: String? = HomeScreenStore2.HomeScreenStore.featured_img_url
            if let img_url = image_url{
                do {
                    //                HomeScreenStore2.FetchAllProjectsFromWeb(completion: updateTableView)
                    let url = URL(string: img_url)
                    let data = try Data(contentsOf: url!)
                    imgView.image = UIImage(data: data)
                    
                    
                    
                }
                catch{
                    print(error)
                }
                
            }
            name.text = HomeScreenStore2.HomeScreenStore.name
            let deeescriptiontemp = HomeScreenStore2.HomeScreenStore.deescription.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            deeescription.text = deeescriptiontemp
            date.text = HomeScreenStore2.HomeScreenStore.date
            //            imgView = UIImageView(image: img!)
            //            imgView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            //            imgView.image = img
            
            
        case let .Failure(error):
            
            print("Error Fetching HomeScreen: \(error)")
        }
        
    }
}
