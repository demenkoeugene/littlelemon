//
//  Onboarding.swift
//  myApp
//
//  Created by Eugene Demenko on 10.06.2023.
//

import SwiftUI

let kIsLoggedIn = "kIsLoggedIn"

let kFirstName = "first name key"
let kLastName = "last name key"
let kEmail = "email key"

struct Onboarding: View {
    @State private var isImageVisible = false
    @State private var isFormView = false
    
    @State private var isLoggedIn = false
    
    @State private var firstName = ""
    @State private var lastNme = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView{
            VStack {
                if isImageVisible {
                    Logo()
                        .transition(.opacity)
                        .offset(y: isImageVisible ? -45 : 0)
                }
                NavigationLink(
                    destination: Home(),
                    isActive: $isLoggedIn,
                    label: {
                        EmptyView()
                            .hidden()
                    }
                )
                if isFormView {
                    ViewForm(
                        firstName: $firstName,
                        lastName: $lastNme,
                        email: $email,
                        isLoggedIn: $isLoggedIn)
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
            if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                isLoggedIn = true
               
            }
        }
    }
}

struct ViewForm: View{
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var isLoggedIn: Bool
    @State var isPressed: Bool = false
    
    init(firstName: Binding<String>, lastName: Binding<String>, email: Binding<String>, isLoggedIn: Binding<Bool>) {
        self._firstName = firstName
        self._lastName = lastName
        self._email = email
        self._isLoggedIn = isLoggedIn
    }
    
    var body: some View{
        VStack{
            Text("Sign Up")
                .font(.custom("Markazi Text", size: 44))
            Group{
                TextField("Name", text: $firstName)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                TextField("Last Name", text: $lastName)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                TextField("Email", text: $email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                VStack{
                    Button("Register"){
                        isPressed.toggle()
                        if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty {
                            UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                            isLoggedIn = true
                        }
                    }
                    .font(.custom("Karla", size: 24))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(isPressed ? Color("#F4CE14") : Color("#495E57") )
                    .cornerRadius(10)
                }
                .font(.custom("Karla", size: 18))
                .padding(.top, 15)
            }
        }
        .offset(y: -50)
    }
}

struct Logo: View{
    var body: some View{
        Image("logo2")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 170, height: 70)
    }
}



struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
