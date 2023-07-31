//
//  AuthenticationManager.swift
//  myApp
//
//  Created by Eugene Demenko on 11.07.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn
import FirebaseCore



protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

var accessSignInWithGoogle = false

@MainActor
class AuthManager: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var errorLogIn: Error?
    @Published var showAlert = false
   
    
    init() {
        self.userSession = Auth.auth().currentUser
      
        Task {
            try await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            showAlert = false
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
           
            try await fetchUser()
           
        } catch {
            showAlert = true
            errorLogIn = error.localizedDescription as? Error
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid,
                            fullName: fullname,
                            email: email,
                            photoURL: nil)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            try await fetchUser()
          
        } catch {
            print("DEBUG: Failed to create user with error: \(error)")
            print("DEBUG: Error description: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func resetPassword(email: String) async throws{
        do{
            try await Auth.auth().sendPasswordReset(withEmail: email)
            self.userSession = nil
            self.currentUser = nil
        }catch{
            print("DEBUG: Failed to reset password with error \(error.localizedDescription)")
        }
    }
    func deleteAccount() {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print("DEBUG: Failed with deleting account \(error.localizedDescription)")
            } else {
                self.showAlert = false
            }
        }
    }
    
    func fetchUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AuthenticationError.tokenError(message: "User ID not found")
        }
        
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        self.currentUser = try snapshot.data(as: User.self)
    }
}

enum AuthenticationError: Error {
    case tokenError(message: String)
    case defaultError(message: String)
    case noRootViewController
}

extension AuthManager {
   
    func signInWithGoogle() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            throw AuthenticationError.noRootViewController
        }


        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

            let user = userAuthentication.user
            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
            let accessToken = user.accessToken

            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                         accessToken: accessToken.tokenString)

            let result = try await Auth.auth().signIn(with: credential)
            self.userSession = result.user
            print("User \(String(describing: userSession?.uid)) signed in with email \(userSession?.email ?? "unknown")")
            
            let newUser = User(id: result.user.uid,
                               fullName: userSession?.displayName ?? "problems",
                               email: userSession?.email ?? "problems",
                               photoURL: userSession?.photoURL)
            let encodedUser = try Firestore.Encoder().encode(newUser)
            try await Firestore.firestore().collection("users").document(newUser.id).setData(encodedUser)
            try await fetchUser()
            
            
            try await fetchUser()
           
           
        }
        catch {
          print(error.localizedDescription)
         
        }
    }
}
