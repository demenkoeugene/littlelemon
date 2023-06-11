//
//  Onboarding.swift
//  myApp
//
//  Created by Eugene Demenko on 10.06.2023.
//

import SwiftUI

let kFirstName = "first name key"
let kLastName = "last name key"
let kEmail = "email key"

struct Onboarding: View {
    @State private var isImageVisible = false
    @State private var isFormView = false
    
    @State private var firstName = ""
    @State private var lastNme = ""
    @State private var email = ""
    
    var body: some View {
        VStack {
            if isImageVisible {
                Logo()
                    .transition(.opacity)
                    .offset(y: isFormView ? -25 : 0)
            }
            ZStack{
                if isFormView {
                    ViewForm(firstName: $firstName, lastName: $lastNme, email: $email)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.7)) {
                isImageVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.easeInOut(duration: 0.7)) {
                    isFormView = true
                }
            }
        }
    }
}

struct ViewForm: View{
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    
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
                        if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty {
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                        }
                    }
                    .font(.custom("Karla", size: 24))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color("#495E57"))
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
