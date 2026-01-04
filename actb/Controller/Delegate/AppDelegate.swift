//
//  AppDelegate.swift
//  BrittsImperial
//
//  Created by Khuss on 25/09/23.
//

//110267@brittscollege.edu.au
//110267@brittscollege

import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardToolbarManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true // optional
        //CheckUpdate.shared.showUpdate(withConfirmation: false)
        UIApplication.shared.statusBarStyle = .lightContent
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}



//class StatusBarManager {
//    static func setStatusBarBackgroundColor(_ color: UIColor) {
//        guard let window = UIApplication.shared.windows.first else { return }
//
//        let tag = 38482  // Any unique number to identify the view
//        if let existingView = window.viewWithTag(tag) {
//            existingView.backgroundColor = color
//        } else {
//            let height = window.safeAreaInsets.top
//            let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: height))
//            statusBarView.backgroundColor = color
//            statusBarView.tag = tag
//            window.addSubview(statusBarView)
//        }
//    }
//}

class StatusBarManager {
    static func setStatusBarBackgroundColor(_ color: UIColor) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            print("Return from setStatusBarBackgroundColor")
            return
        }

        let tag = 38482 // unique ID for the status bar view
        let height = window.safeAreaInsets.top

        if let existingView = window.viewWithTag(tag) {
            print("existingView setStatusBarBackgroundColor")
            existingView.backgroundColor = color
            existingView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: height)
        } else {
            print("Add from setStatusBarBackgroundColor")
            let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: height))
            statusBarView.backgroundColor = color
            statusBarView.tag = tag
            statusBarView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin] // adjust on rotation
            window.addSubview(statusBarView)
        }
    }
    
    static func removeStatusBarBackground() {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }),
                  let existingView = window.viewWithTag(38482) else {
                print("No status bar background to remove")
                return
            }

            print("Removing status bar background")
            existingView.removeFromSuperview()
        }
}
