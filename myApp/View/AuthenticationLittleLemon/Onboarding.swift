//
//  Onboarding.swift
//  myApp
//
//  Created by Eugene Demenko on 10.06.2023.
//

import SwiftUI

//@MainActor
//final class SignUpEmailViewModel: ObservableObject{
//    @Published var yourName = ""
//    @Published var email = ""
//    @Published var password = ""
//
//
//    func signUp() async throws {
//        guard !email.isEmpty, !password.isEmpty else{
//            print("No email is not found")
//            return
//        }
//
//        _ = try await AuthenticationManager.shared.createUser(
//                            email: email,
//                            password: password)
//    }
//    func signIn() async throws {
//        guard !email.isEmpty, !password.isEmpty else{
//            print("No email is not found")
//            return
//        }
//
//        _ = try await AuthenticationManager.shared.signInUser(
//                            email: email,
//                            password: password)
//    }
//}


struct Onboarding: View {
    @State private var isImageVisible = false
    @State private var isFormView = false
    @State private var isLoggingIn: Bool = false
    
    @StateObject private var viewModel = AuthViewModel()
    @Binding var showSingInView: Bool
    
    var body: some View {
        NavigationStack{
            VStack {
                if isImageVisible {
                    Logo()
                        .transition(.opacity)
                        .offset(y: isImageVisible ? -45 : 0)
                }

                if isFormView {
                        SignInView(viewmodel: viewModel, showSingInView: $showSingInView)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isImageVisible = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        isFormView = true
                    }
                }
            }
        }
        
        .onAppear {
           
        }
    }
}
struct SignInView: View{
    @State private var email = ""
    @State private var password = ""
    @StateObject private var viewmodel: AuthViewModel
    
    @Binding var showSingInView: Bool
    @State var isPressed: Bool = false
    @Environment(\.dismiss) var dismiss

    init(viewmodel: AuthViewModel, showSingInView: Binding<Bool>) {
        self._viewmodel = StateObject(wrappedValue: viewmodel)
        self._showSingInView = showSingInView
    }
    
    var body: some View{
        VStack{
            Text("Sign Up")
                .font(.custom("Markazi Text", size: 44))
            Group{
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
                    
                VStack{
                    Button{
                        isPressed.toggle()
                        Task {
                            do{
                                try await viewmodel.signIn(withEmail: email, password: password)
                                showSingInView = false
                                return
                            }catch{
                                print(error)
                            }
                        }
                    }label:{
                        Text("Sign in")
                    }
                    .buttonStyle(ButtonColor())
                }
                .font(.custom("Karla", size: 18))
                .padding(.top, 15)
            }
            
            NavigationLink {
                
            } label: {
                HStack(spacing: 3){
                    Text ("Don't have an account?")
                    Text("Sign up")
                        .fontWeight (.bold)
                }
                .font(.custom("Karla", size: 16))
            }
            .padding(.top, 20)
           
            
        }
        .offset(y: -50)
    }
}


struct SignUpView: View{
    @StateObject private var authViewModel: AuthViewModel
    @Binding var showSingInView: Bool
    @State var isPressed: Bool = false
   

    init(authViewModel: AuthViewModel, showSingInView: Binding<Bool>) {
        self._authViewModel = StateObject(wrappedValue: authViewModel)
        self._showSingInView = showSingInView
    }
    
    var body: some View{
        VStack{
            Text("Sign Up")
                .font(.custom("Markazi Text", size: 44))
            Group{
////                TextField("Name", text: $authViewModel.fullName)
////                    .padding()
////                    .frame(width: 300, height: 50)
////                    .background(Color.black.opacity(0.05))
////                    .cornerRadius(10)
//                TextField("Email", text: $authViewModel.email)
//                    .padding()
//                    .frame(width: 300, height: 50)
//                    .background(Color.black.opacity(0.05))
//                    .cornerRadius(10)
//                SecureField("Password", text: $authViewModel.password)
//                    .padding()
//                    .frame(width: 300, height: 50)
//                    .background(Color.black.opacity(0.05))
//                    .cornerRadius(10)
                    
                VStack{
//                    Button{
//                        isPressed.toggle()
//                        Task {
//                            do{
//                                try await $authViewModel.signUp()
//                                showSingInView = false
//                                return
//                            }catch{
//                                print(error)
//                            }
//                        }
//                    }label:{
//                        Text("Sign Up")
//                    }
//                    .buttonStyle(ButtonColor())
                }
                .font(.custom("Karla", size: 18))
                .padding(.top, 15)
            }
            
            NavigationLink {
                
            } label: {
                HStack(spacing: 3){
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight (.bold)
                }
                .font(.custom("Karla", size: 16))
            }
            .padding(.top, 20)
           
            
        }
        .offset(y: -50)
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



struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            Onboarding(showSingInView: .constant(false))
        }
    }
}
