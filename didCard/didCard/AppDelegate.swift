//
//  AppDelegate.swift
//  didCard
//
//  Created by wesley on 2021/1/20.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let rootVC = window?.rootViewController as? ViewController {
            rootVC.container = DataShareManager.sharedInstance.persistentContainer
        }
        //initial view controller
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        var initialViewController: UIViewController
//
//        if !Wallet.WInst.hasAccount {
////            initialViewController = mainStoryboard.instantiateInitialViewController()!
//            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
//        } else {
//            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "CreateVC")
//        }
//
//        self.window?.rootViewController = initialViewController
//
//        self.window?.makeKeyAndVisible()

        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NSLog("=======>timer invalidate--->")
//        let context = DataShareManager.sharedInstance.persistentContainer.viewContext
        DataShareManager.sharedInstance.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        DataShareManager.sharedInstance.saveContext()
    }

}

