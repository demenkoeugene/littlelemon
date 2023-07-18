//
//  myAppApp.swift
//  myApp
//
//  Created by Eugene Demenko on 08.06.2023.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
      }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}


@main
struct myAppApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    init(){
//        FirebaseApp.configure()
//    }
    @StateObject var viewmodel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(viewmodel)
        }
    }
}

