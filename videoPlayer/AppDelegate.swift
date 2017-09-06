//
//  AppDelegate.swift
//  videoPlayer
//
//  Created by 蘇冠禎 on 2017/9/6.
//  Copyright © 2017年 蘇冠禎. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let viewController = PlayViewController()

        self.window?.rootViewController = viewController
        
        self.window?.makeKeyAndVisible()

        return true
    }
}

