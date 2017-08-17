//
//  AppDelegate.swift
//  finalEcommerce
//
//  Created by Trong Nghia Hoang on 9/24/16.
//  Copyright © 2016 Trong Nghia Hoang. All rights reserved.
//

import UIKit
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if (!UserDefaults.standard.bool(forKey: "HasLaunchedOnce")){
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
            let key = Keychain()
            key.setPasscode("email", passcode: "");
            key.setPasscode("password", passcode: "");
        } else {
            let tab =  TabbarController()
            let login = SignInViewController()
            let key = Keychain()
            print(key.getPasscode("password")!)
            if key.getPasscode("password")! != "" || key.getPasscode("email")! != "" {
                //BEGIN LOGOUT
                login.logout()
                //BEGIN LOGIN
                login.login(key.getPasscode("email") as! String, passwordString: key.getPasscode("password") as! String, completionHandler: { (success) -> Void in
                    //LOGGING IN
                    // When download completes,control flow goes here.
                    if success {
                        tab.loadData(completionHandler: { (ok) -> Void in
                            if ok {
                               let tbc : UITabBarController = (self.window!.rootViewController as? UITabBarController)!
                                tbc.tabBar.items?[3].badgeValue = "\(tab.count)"
                                //FINISH LOGGING IN
                            }
                        })     
                    } else {
                        print("fail")
                    }
                })
                
            }
            //KingfisherManager.shared.cache.clearMemoryCache()
            //KingfisherManager.shared.cache.clearDiskCache()
            // Sets background to a blank/empty image
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            // Sets shadow (line below the bar) to a blank image
            UINavigationBar.appearance().shadowImage = UIImage()
            // Sets the translucent background color
            UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            // Set translucent. (Default value is already true, so this can be removed if desired.)
            UINavigationBar.appearance().isTranslucent = true
            

        }
        return true

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

