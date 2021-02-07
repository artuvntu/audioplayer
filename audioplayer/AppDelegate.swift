//
//  AppDelegate.swift
//  audioplayer
//
//  Created by Arturo Ventura on 04/02/21.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appRealm = App(id: "application-0-oixfk")
        appRealm.login(credentials: Credentials.anonymous) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let user):
                print(user)
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }


}

