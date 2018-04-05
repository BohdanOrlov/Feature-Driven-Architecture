//
//  AppDelegate.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 17/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import UIKit
import UI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowOwner {
    var windows = [String : UIWindow]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        MainFlow.start(windowOwner: self)
        return true
    }
}

