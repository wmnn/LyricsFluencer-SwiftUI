//
//  UserContext.swift
//  LyricsFluencer
//
//  Created by Peter Christian Würdemann on 04.11.24.
//
import SwiftUI

class UserContext: ObservableObject {
    
    @Published var user: User?
    let userModel = UserModel()
    
    init () {
        
        // Handle auto login
        userModel.getCurrentUser{ user, error in
            
            guard error == nil && user != nil else {
                print("user is not logged in")
                return;
            }
            
            self.user = user;
            print(user!)
        }
        
    }
    
    func register(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        
        userModel.register (email: email, password: password){ user, error in
            
            guard error == nil && user != nil else {
                print("register Error")
                completion(nil, error)
                return;
            }
            
            
            self.user = user;
            completion(user!, nil);
        }
        
    }
    
    func login(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        
        userModel.login(email: email, password: password){ user, error in
            
            guard error == nil && user != nil else {
                print("login error")
                completion(nil, error)
                return;
            }
            
            
            self.user = user;
            completion(user!, nil);
        }
        
    }
    
    func updateSettings(nativeLanguage: String, learnedLanguage: String, completion: @escaping (User?, Error?) -> Void) {
        
        userModel.updateSettings(nativeLanguage: nativeLanguage, learnedLanguage: learnedLanguage) { user, error in
            
            guard error == nil && user != nil else {
                print("update settings error")
                completion(nil, error)
                return;
            }
            
            DispatchQueue.main.async {
                self.user = user;
                completion(user, nil)
            }
        }
    }
    
    func logout(completion: @escaping (Error?) -> Void) {
        
        userModel.logout { error in
            guard error == nil else {
                completion(error)
                return;
            }
            
            DispatchQueue.main.async {
                self.user = nil;
                completion(nil)
            }
        }
        
    }
    
    func handleDelete(appContext: AppContext) {
        userModel.deleteUser(){ error in
            guard error == nil else {
                return;
            }
            self.logout(){ error in
                guard error == nil else {
                    return;
                }
                appContext.resetNavigationPath()
            }
        }
        
    }
    
}
