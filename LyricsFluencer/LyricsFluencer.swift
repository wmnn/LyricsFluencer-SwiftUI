//
//  TranslationAppApp.swift
//  TranslationAppApp
//
//  Created by Peter Christian Würdemann on 12.02.23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // This method is called when the app finishes launching.
        print("Launched")
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // This method is called when the app becomes active.
        print("App is active")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // This method is called when the app is about to become inactive.
        print("App is about to become inactive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // This method is called when the app goes into the background.
        print("App is in the background")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // This method is called when the app is about to terminate.
        print("App is about to terminate")
    }
     
}



@main
struct LyricsFluencer: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appBrain = AppBrain()
    @StateObject var deckContext = DeckContext()
    @StateObject var songContext = SongContext()
    
    init() {
        print("My App is starting")
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(appBrain)
                .environmentObject(deckContext)
                .environmentObject(songContext)
                
        }
    }
}
