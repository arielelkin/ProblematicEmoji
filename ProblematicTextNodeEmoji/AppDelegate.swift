//
//  AppDelegate.swift
//  ProblematicTextNodeEmoji
//
//  Created by Ariel Elkin on 09/03/2018.
//  Copyright © 2018 Ariel Elkin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MyCommentVC()
        window?.makeKeyAndVisible()
        return true
    }
}

