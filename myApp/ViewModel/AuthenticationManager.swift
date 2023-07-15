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


protocol AuthenticationFormProtocol{
    var formIsValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var errorLogIn: Error?
    @Published var showAlert = false
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do{
            showAlert = false
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch{
            showAlert = true
            errorLogIn = error.localizedDescription as? any Error
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error: \(error)")
            print("DEBUG: Error description: \(error.localizedDescription)")
        }
    }

    func signOut() {
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }catch{
            
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func resetPassword(email: String) async throws{
        let result = try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    func deleteAccount() {
        
    }
    
    func fetchUser() async{
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
            self.currentUser = try? snapshot.data(as: User.self)
    }
}

