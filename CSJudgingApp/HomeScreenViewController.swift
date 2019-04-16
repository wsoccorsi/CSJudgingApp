//
//  HomeScreenViewController.swift
//  CSJudgingApp
//
//  Created by Jason Campbell on 3/27/19.
//  Copyright © 2019 William  Soccorsi. All rights reserved.
//

import UIKit

class HomeScreenViewController : UIViewController {
    
    var HomeScreen : HomeScreen!
    var img : UIImage!
    
    @IBOutlet var imgView : UIImageView!
    @IBOutlet var name : UILabel!
    @IBOutlet var deeescription: UILabel!
    @IBOutlet var date : UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let API = WebAPI()
        API.FetchHomeScreenFromWeb(completion: updateView)
        
    }
    
    func updateView(homeScreenResult: HomeScreenResult) {
        
        switch homeScreenResult
        {
            case let .Success(HomeScreen):
                
                let image_url: String? = HomeScreen.featured_img_url
                if let img_url = image_url
                {
                    do {
                        let url = URL(string: img_url)
                        let data = try Data(contentsOf: url!)
                        imgView.image = UIImage(data: data)
                    }
                    catch {
                        print(error)
                    }
                }
                
                name.text = HomeScreen.name
                
                let deeescriptiontemp = HomeScreen.deescription.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                deeescription.text = deeescriptiontemp
                
                date.text = HomeScreen.date
            
            case let .Failure(error):
                print("Error Fetching HomeScreen: \(error)")
        }        
    }
}
