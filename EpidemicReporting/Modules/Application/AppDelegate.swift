//
//  AppDelegate.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/11/9.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import UIKit
import CoreData
import Sync

var appDelegate: AppDelegate {
    return (UIApplication.shared.delegate as? AppDelegate)!
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    public var currentUser: User? {
        didSet {
            //update User informaton
            print("current user's id is: \(String(describing: currentUser?.username))")
        }
    }
    
    lazy var dataStack: DataStack = {
        let dataStack = DataStack(modelName: "EpidemicReporting")
        return dataStack
    }()
    
    fileprivate var tabbarController: UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.loginSuccess), name: NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
        // Override point for customization after application launch.
        
//        let rooNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarNav") as? UINavigationController
//        if tabbarController == nil {
//            tabbarController = rooNav?.childViewControllers.first as? UITabBarController
//            self.window?.rootViewController = rooNav
//        } else {
//            self.window?.rootViewController = rooNav
//        }
//
//        initTabar(true)
        
        //map usage
        AMapServices.shared().apiKey = "18b32346a4d880b4dc95e580c8850a1c"
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "EpidemicReporting")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func initTabar(_ isAdmin: Bool) {
        let selfCheckVC = isAdmin ? UIStoryboard(name: "SelfCheck", bundle: nil).instantiateViewController(withIdentifier: "SelfCheckAdminNav") : UIStoryboard(name: "SelfCheck", bundle: nil).instantiateInitialViewController()!
        selfCheckVC.tabBarItem.image = UIImage.init(named: "locate")
        selfCheckVC.tabBarItem.title = "签到"
        
        let messageVC = UIStoryboard(name: "Message", bundle: nil).instantiateInitialViewController()!
        messageVC.tabBarItem.image = UIImage.init(named: "message")
        messageVC.tabBarItem.title = "消息"
        
        let reportVC = UIStoryboard(name: "Report", bundle: nil).instantiateInitialViewController()!
        reportVC.tabBarItem.image = UIImage.init(named: "report")
        reportVC.tabBarItem.title = "疫情上报"
        
        let reportListVC = UIStoryboard(name: "ReportList", bundle: nil).instantiateInitialViewController()!
        reportListVC.tabBarItem.image = UIImage.init(named: "reportList")
        reportListVC.tabBarItem.title = "疫情汇总"
        
        
        
        tabbarController?.viewControllers = isAdmin ? [selfCheckVC, reportVC, messageVC, reportListVC]: [selfCheckVC, reportVC, messageVC]
    }
    
    @objc func loginSuccess() {

        if tabbarController == nil {
            tabbarController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarNav") as? UINavigationController)?.childViewControllers.first as? UITabBarController
            self.window?.rootViewController = tabbarController
        }else{
            self.window?.rootViewController = tabbarController
        }
        
        var isAdmin = false
        if let type = appDelegate.currentUser?.role {
            isAdmin = type == RoleType.admin.rawValue ? true : false
        }
        initTabar(isAdmin)
    }
}

