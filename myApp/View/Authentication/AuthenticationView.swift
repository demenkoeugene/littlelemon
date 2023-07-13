//
//  AuthenticationView.swift
//  myApp
//
//  Created by Eugene Demenko on 11.07.2023.
//

import SwiftUI

struct AuthenticationView: View {

    var body: some View {
        VStack{
            NavigationLink{
//                SignInEmailView(showSingInView: $showSignInView)
            }label: {
                Text("Sign in with Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Sign In")
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
            NavigationStack{
//                AuthenticationView(showSignInView: .constant(false))
            }
    }
}
