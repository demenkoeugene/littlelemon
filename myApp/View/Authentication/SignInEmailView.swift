//
//  SignInEmailView.swift
//  myApp
//
//  Created by Eugene Demenko on 11.07.2023.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject{
    @Published var yourName = ""
    @Published var email = ""
    @Published var password = ""
    func SignIn(){
        guard !email.isEmpty, !password.isEmpty else{
            print("No email is not found")
            return
        }
        Task{
            do{
                let returnedUserData = try await AuthenticationManager.shered.createUser(
                        email: email,
                        password: password)
                print("Success")
                print(returnedUserData)
            }catch{
                print("Error: \(error)")
            }
        }
      
    }
}
struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    var body: some View {
        VStack{
           TextField("Name...", text: $viewModel.yourName)
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
            TextField("Email...", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
            SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
            Button{
                viewModel.SignIn()
            }label:{
                Text("Sign in")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SignInEmailView()
        }
    }
}
