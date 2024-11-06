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
    @StateObject var appContext = AppContext()
    @StateObject var deckContext = DeckContext()
    @StateObject var songContext = SongContext()
    @StateObject var userContext = UserContext()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            
            NavigationStack(path: $appContext.path){
                    ZStack {
                        Color.background
                            .ignoresSafeArea()
                        
                        ZStack{
                            if userContext.user != nil {
                                HomeView()
                                    .environmentObject(appContext)
                                    .environmentObject(deckContext)
                                    .environmentObject(songContext)
                                    .environmentObject(userContext)
                            } else {
                                LoginView()
                                    .environmentObject(appContext)
                                    .environmentObject(deckContext)
                                    .environmentObject(songContext)
                                    .environmentObject(userContext)
                            }
                        }
                    }
                    .navigationDestination(for: String.self){ stringVal in
                            
                        switch stringVal {
                        case Views.Login.rawValue:
                            LoginView()
                                .environmentObject(appContext)
                                .environmentObject(deckContext)
                                .environmentObject(songContext)
                                .environmentObject(userContext)
                        case Views.Home.rawValue:
                            HomeView()
                                .environmentObject(appContext)
                                .environmentObject(deckContext)
                                .environmentObject(songContext)
                                .environmentObject(userContext)
                        case Views.Lyrics.rawValue:
                            LyricsView()
                                .environmentObject(appContext)
                                .environmentObject(deckContext)
                                .environmentObject(songContext)
                                .environmentObject(userContext)
                        case Views.Flashcards.rawValue:
                            DecksView()
                                .environmentObject(appContext)
                                .environmentObject(deckContext)
                                .environmentObject(songContext)
                                .environmentObject(userContext)
                        case Views.DeckSettingsView.rawValue:
                            DeckSettingsView()
                                .environmentObject(appContext)
                                .environmentObject(deckContext)
                                .environmentObject(songContext)
                                .environmentObject(userContext)
                        case Views.CardsView.rawValue:
                            CardView()
                                .environmentObject(appContext)
                                .environmentObject(deckContext)
                                .environmentObject(songContext)
                                .environmentObject(userContext)
                        case Views.EditCardsView.rawValue:
                            EditCardsView()
                                .environmentObject(appContext)
                                .environmentObject(deckContext)
                                .environmentObject(songContext)
                                .environmentObject(userContext)
                        case Views.Settings.rawValue:
                            SettingsView()
                                .environmentObject(appContext)
                                .environmentObject(deckContext)
                                .environmentObject(songContext)
                                .environmentObject(userContext)
                        case Views.Browse.rawValue:
                            BrowseView()
                                .environmentObject(appContext)
                                .environmentObject(deckContext)
                                .environmentObject(songContext)
                                .environmentObject(userContext)
                        case Views.Register.rawValue:
                            RegisterView()
                                .environmentObject(appContext)
                                .environmentObject(deckContext)
                                .environmentObject(songContext)
                                .environmentObject(userContext)
                        default:
                            LoginView()
                                .environmentObject(appContext)
                                .environmentObject(deckContext)
                                .environmentObject(songContext)
                                .environmentObject(userContext)
                        }
                    }
            }
            
        }
    }
    
}
