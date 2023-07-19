//
//  AuthView.swift
//  myApp
//
//  Created by Eugene Demenko on 14.07.2023.
//

import SwiftUI

struct SignInView: View{
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @State var isPressed: Bool = false
    
    
    var body: some View{
        VStack{
            NavigationStack{
                Spacer()
                Spacer()
                Logo()
                Text("Sign In")
                    .font(.custom("Markazi Text", size: 44))
                Group{
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke($authViewModel.showAlert.wrappedValue ? Color.red : Color.clear, lineWidth: 1)
                        )
                    
                    
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke($authViewModel.showAlert.wrappedValue ? Color.red : Color.clear, lineWidth: 1)
                        )
                    
                    NavigationLink{
                        ForgotPasswordView()
                    }label:{
                        Text("Forgot password?")
                            .frame(width: 300, height: 50, alignment: .trailing)
                            .font(.custom("Karla", size: 16))
                    }
                    
                    VStack{
                        Button{
                            isPressed.toggle()
                            Task {
                                do{
                                    try await authViewModel.signIn(withEmail: email, password: password)
                                    accessSignInWithGoogle = true
                                }catch{
                                    
                                }
                            }
                        }label:{
                            Text("Sign in")
                        }
                        .buttonStyle(ButtonColor())
                    }
                    .font(.custom("Karla", size: 18))
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    
                    HStack {
                        VStack { Divider()}
                        Text("or")
                        VStack { Divider()}
                    }
                    .font(.custom("Karla", size: 14))
                    .frame(width: 300, height: 50)
                    .padding([.top, .bottom], 3)
                    .frame(width: 300, height: 50)
                    
                    VStack {
                        Button(action: {
                            isPressed.toggle()
                            Task {
                                do {
                                    try await authViewModel.signInWithGoogle()
                                    accessSignInWithGoogle = false
                                } catch {
                                    print("Google Sign-In error:", error.localizedDescription)
                                }
                            }
                        }) {
                            HStack(alignment: .center) {
                                Image("googlecolor")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 35)
                                    .padding(.trailing, 5)
                                Text("Sign in with Google")
                            }
                        }
                        .buttonStyle(ButtonColor())
                        .font(.custom("Karla", size: 16))
                    }
                }
                
                
                
                if $authViewModel.showAlert.wrappedValue {
                    Text("Please check the username or password you entered. It seems they are incorrect.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.red)
                        .font(.custom("Karla", size: 14))
                        .frame(width: 300, height: 50)
                        .lineLimit(2)
                        .padding(.top, 15)
                }else{
                    Spacer()
                        .frame(width: 300, height: 50)
                        .lineLimit(2)
                        .padding(.top, 15)
                }
                
                Spacer()
                NavigationLink {
                    SignUpView()
                } label: {
                    HStack(spacing: 3){
                        Text ("Don't have an account?")
                        Text("Sign up")
                            .fontWeight (.bold)
                    }
                    .font(.custom("Karla", size: 16))
                }
                
                .padding(.top, 20)
                .offset(y: -30)
                
            }
        }
        
        
    }
}

extension SignInView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains ("@")
        && !password.isEmpty
        && password.count > 5
    }
}


struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack{
            NavigationStack{
                Spacer()
                Spacer()
                Logo()
                Text("Sign Up")
                    .font(.custom("Markazi Text", size: 44))
                Group {
                    TextField("Name", text: $fullName)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    VStack {
                        Button(action: {
                            isPressed.toggle()
                            Task {
                                do {
                                    try await authViewModel.createUser(withEmail: email, password: password, fullname: fullName)
                                } catch {
                                    print("Error press log in: \(error)")
                                }
                            }
                        }) {
                            Text("Sign Up")
                        }
                        .buttonStyle(ButtonColor())
                    }
                    .font(.custom("Karla", size: 18))
                    .padding(.top, 15)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                }
                
                Spacer()
                    .frame(width: 300, height: 50)
                    .lineLimit(2)
                    .padding(.top, 15)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                    .font(.custom("Karla", size: 16))
                }
                .padding(.top, 20)
                
            }
            
        }
        .offset(y: -30)
        .navigationBarBackButtonHidden(true)
    }
}

extension SignUpView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains ("@")
        && !password.isEmpty
        && password.count > 5
        && !fullName.isEmpty
    }
}
struct ButtonColor: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Karla", size: 24))
            .frame(width: 280, height: 30)
            .foregroundColor(configuration.isPressed ? .black : .white)
            .padding(10)
            .background(configuration.isPressed ? Color("#F4CE14") : Color("#495E57"))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

struct Logo: View{
    var body: some View{
        Image("logo2")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 200, height: 55)
    }
}


