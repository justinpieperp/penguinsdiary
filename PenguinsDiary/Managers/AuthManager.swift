//
//  AuthManager.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 7/20/21.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private init() {}
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signUp (
        email: String,
        pwd: String,
        completion: @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !pwd.trimmingCharacters(in: .whitespaces).isEmpty,
              pwd.count >= 6 else {
            return
        }
        
        auth.createUser(withEmail: email, password: pwd) {
            result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            // account created
            completion(true)
        }
    }
    
    public func signIn (email: String, pwd: String, completion: @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !pwd.trimmingCharacters(in: .whitespaces).isEmpty else {
            completion(false)
            return
        }
        
        auth.signIn(withEmail: email, password: pwd) {
            result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            // user signed in
            completion(true)
        }
    }
    
    public func signOut(completion: (Bool) -> Void) {
        do {
            try auth.signOut()
            completion(true)
        } catch {
            completion(false)
            print(error)
        }
    }
}
