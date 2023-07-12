//
//  SettingsView.swift
//  myApp
//
//  Created by Eugene Demenko on 11.07.2023.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject{
    func signOut() throws {
        AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else{
            throw URLError(.fileDoesNotExist )
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws{
        let email = "hello123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws{
        let password = "Hello123!"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}



struct SettingsView: View {
    
    @StateObject private var viewmodel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List{
            Button("Log out"){
                Task {
                    do{
                        try viewmodel.signOut()
                        showSignInView  = true
                    }catch{
                        print(error)
                    }
                }
            }
            Button("Reset password"){
                Task {
                    do{
                        try await viewmodel.resetPassword()
                        print("RESET PASSWORD!")
                    }catch{
                        print(error)
                    }
                }
            }
            Button("Update password"){
                Task {
                    do{
                        try await viewmodel.updatePassword()
                        print("PASSWORD UPDATED!")
                    }catch{
                        print(error)
                    }
                }
            }
            Button("Update email"){
                Task {
                    do{
                        try await viewmodel.resetPassword()
                        print("EMAIL UPDATED!")
                    }catch{
                        print(error)
                    }
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SettingsView(showSignInView: .constant(false))
        }
    }
}
