//
//  UserProfile.swift
//  myApp
//
//  Created by Eugene Demenko on 12.06.2023.
//

import SwiftUI

@MainActor
final class UserProfileSettings: ObservableObject{
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

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    @StateObject private var viewModel = UserProfileSettings()
    @Binding var showSignInView: Bool
 

    
    var body: some View {
        VStack{
            Header()
                .padding(.top, 10)
            VStack(alignment: .leading){
                HStack(){
                    Image("profile-image-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(180)
                    VStack(alignment: .leading) {
                        Text("\(UserModel.MOCK_USER.fullName)")
                                                .font(.custom("Karla", size: 28))
                        Text("\(UserModel.MOCK_USER.email)")
                                                .font(.custom("Karla", size: 14))
                                                .foregroundColor(Color("#EDEFEE"))
                    }
                    Spacer()
                    Button{
                        
                    }label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: 340)
            }
           
            
           
            List{
                Button("\( Image(systemName: "creditcard")) Payment methods"){
                    
                }
                .listRowSeparator(.hidden)
                .padding([.top, .bottom], 8)
                Button("\( Image(systemName: "tag")) Promo code"){
                    
                }
                .listRowSeparator(.hidden)
                .padding([.top, .bottom], 8)
                Button("\( Image(systemName: "gearshape")) Settings"){
                    
                }
                .listRowSeparator(.hidden)
                .padding([.top, .bottom], 8)
                Button("\( Image(systemName: "info.circle")) About us"){
                    
                }
                .listRowSeparator(.hidden)
                .padding([.top, .bottom], 8)
                Button("\( Image(systemName: "questionmark.circle")) Support"){
                    
                }
                .listRowSeparator(.hidden)
                .padding([.top, .bottom], 8)
                Button("\( Image(systemName: "door.left.hand.open")) Log out"){
                    Task {
                        do{
                            try viewModel.signOut()
                            showSignInView  = true
                        }catch{
                            print(error)
                        }
                    }
                }
                .foregroundColor(.red)
                .padding([.top, .bottom], 8)
            }
            .scrollContentBackground(.hidden)
            .foregroundColor(.black)
            .font(.custom("Karla", size: 18))
        }
        
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(showSignInView: .constant(false))
    }
}
