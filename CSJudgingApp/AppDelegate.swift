//
//  AppDelegate.swift
//  CSJudgingApp
//
//  Created by William  Soccorsi on 3/17/19.
//  Copyright © 2019 William  Soccorsi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let API = WebAPI();
    
    let Data = CoreData();
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        API.Data = Data
        
        let TabBarController = window!.rootViewController as! UITabBarController
        let ViewControllers: Array = TabBarController.viewControllers!
        
        let homeScreen = HomeScreen()
        let HomeNavigationController = ViewControllers[0] as! UINavigationController
        let HomeScreenController = HomeNavigationController.topViewController as! HomeScreenViewController
        HomeScreenController.HomeScreen = homeScreen
        HomeScreenController.API = API
        HomeScreenController.CData = Data
        
        let allProjectStore = ProjectStore()
        let AllProjNavigationController = ViewControllers[1] as! UINavigationController
        let ProjectsController = AllProjNavigationController.topViewController as! ProjectsViewController
        ProjectsController.ProjectStore = allProjectStore
        ProjectsController.API = API
        ProjectsController.CData = Data
        
        let myProjectStore = ProjectStore()
        let MyProjNavigationController = ViewControllers[2] as! UINavigationController
        let JudgingController = MyProjNavigationController.topViewController as! JudgingViewController
        JudgingController.ProjectStore = myProjectStore
        JudgingController.API = API
        JudgingController.CData = Data
        
        let QRProjectStore = ProjectStore()
        let QRController = ViewControllers[3] as! QRScannerController
        QRController.ProjectStore = QRProjectStore
        QRController.API = API
        
        if (Data.userDataExists()) {
            
            API.Username = Data.getUsernameFromCore()
            API.Password = Data.getPasswordFromCore()
            
            if (false) { // Data.isTokenOld()
                // Generate New Token
            }
            else {
                API.BearerToken = Data.getTokenFromCore()
            }
            
            ProjectsController.viewDidLoad()
            JudgingController.viewDidLoad()
        }
        else {
            print("No Core Data: Login Required")
        }
        
        return true
    }
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

