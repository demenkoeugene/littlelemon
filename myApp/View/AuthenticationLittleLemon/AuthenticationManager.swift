//
//  AuthenticationManager.swift
//  myApp
//
//  Created by Eugene Demenko on 11.07.2023.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel{
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        
    }
}

final class AuthenticationManager{
    static let shared = AuthenticationManager()
    private init(){}
    
    func getAuthenticatedUser() throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func updatePassword(password: String) async throws{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        try await user.updateEmail(to: password)
    }
    
    func updateEmail(email: String) async throws{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        try await user.updateEmail(to: email)
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    func resetPassword(email: String) async throws {
       try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    func signOut(){
        try? Auth.auth().signOut()
    }
}
