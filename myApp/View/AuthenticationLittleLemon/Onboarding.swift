//
//  Onboarding.swift
//  myApp
//
//  Created by Eugene Demenko on 10.06.2023.
//

import SwiftUI

@MainActor
final class SignUpEmailViewModel: ObservableObject{
    @Published var yourName = ""
    @Published var yourLastName = ""
    @Published var email = ""
    @Published var password = ""
   
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else{
            print("No email is not found")
            return
        }
        
        let returnedUserData = try await AuthenticationManager.shared.createUser(
                            email: email,
                            password: password)
    }
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else{
            print("No email is not found")
            return
        }
        
        let returnedUserData = try await AuthenticationManager.shared.signInUser(
                            email: email,
                            password: password)
    }
}


struct Onboarding: View {
    @State private var isImageVisible = false
    @State private var isFormView = false
    
    @StateObject private var viewModel = SignUpEmailViewModel()
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
                    ViewForm(emailViewModel: viewModel, showSingInView: $showSingInView)
                }
            }
//            .navigationDestination(isPresented: $isLoggedIn) {
//               Home()
//            }
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


struct ViewForm: View{
   
    
    @StateObject private var emailViewModel: SignUpEmailViewModel
    @Binding var showSingInView: Bool
    @State var isPressed: Bool = false

    init(emailViewModel: SignUpEmailViewModel, showSingInView: Binding<Bool>) {
        self._emailViewModel = StateObject(wrappedValue: emailViewModel)
        self._showSingInView = showSingInView
    }
    
    var body: some View{
        VStack{
            Text("Sign Up")
                .font(.custom("Markazi Text", size: 44))
            Group{
                TextField("Name", text: $emailViewModel.yourName)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                TextField("Last Name", text: $emailViewModel.yourLastName)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                TextField("Email", text: $emailViewModel.email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                SecureField("Password", text: $emailViewModel.password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    
                VStack{
                    Button{
                        isPressed.toggle()
                        Task {
                            do{
                                try await emailViewModel.signUp()
                                showSingInView = false
                                return
                            }catch{
                                print(error)
                            }
                        }
                        
                        Task {
                            do{
                                try await emailViewModel.signIn()
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
