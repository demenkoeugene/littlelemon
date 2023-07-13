//
//  Onboarding.swift
//  myApp
//
//  Created by Eugene Demenko on 10.06.2023.
//

import SwiftUI




struct Onboarding: View {
    @State private var isImageVisible = false
    @State private var isFormView = false
    
    
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        
        NavigationStack{
           
            VStack {
                if isImageVisible {
                    Logo()
                        .transition(.opacity)
                        .offset(y: isImageVisible ? -45 : 0)
                }

                if isFormView {
                    if viewModel.userSession != nil {
                        Home()
                    }else{
                        SignInView()
                    }
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
    }
}
struct SignInView: View{
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @State var isPressed: Bool = false
    

    
    
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
                            try await authViewModel.signIn(withEmail: email, password: password)
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
           
            
        }
        .offset(y: -50)
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
        Logo()
            .offset(y: -45)
        VStack {
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
            }
            
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign up")
                        .fontWeight(.bold)
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
            Onboarding()
        }
    }
}
