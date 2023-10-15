//
//  AppDelegate.swift
//  AstonProject001
//
//  Created by Георгий Евсеев on 21.09.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        createVC1()

        return true
    }

    func createVC1() {
        window = UIWindow()
        window!.rootViewController = UINavigationController(rootViewController: ViewController())
        window!.makeKeyAndVisible()
    }
}
