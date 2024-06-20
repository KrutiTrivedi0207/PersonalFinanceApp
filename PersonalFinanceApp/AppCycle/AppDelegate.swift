//
//  AppDelegate.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit
import CoreData
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func sharedInstance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance.restorePreviousSignIn { [self] user, error in
            if error != nil || user == nil {
                print("Show the app's signed-out state.")
                goto(isLogin: false)
            } else {
                print("Show the app's signed-in state.")
                goto(isLogin: true)
                
            }
        }
        return true
    }
    
    func goto(isLogin: Bool) {
        if isLogin {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let dashboardVC = mainStoryboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            let nav1 = UINavigationController()
            nav1.viewControllers = [dashboardVC]
            nav1.isNavigationBarHidden = true
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = nav1
            self.window?.makeKeyAndVisible()
        }else {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let nav1 = UINavigationController()
            nav1.isNavigationBarHidden = true
            nav1.viewControllers = [loginVC]
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = nav1
            self.window?.makeKeyAndVisible()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }

}

extension Date {

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)?.setTime(hour: 0, min: 0, sec: 0)
        return date!
    }
    
    func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone.current
        var components = cal.dateComponents(x, from: self)
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec
        return cal.date(from: components)
    }

}

