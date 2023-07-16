//
//  ForgotPasswordView.swift
//  myApp
//
//  Created by Eugene Demenko on 16.07.2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var email = ""
    @State var isPressed: Bool = false
    var body: some View {
        NavigationStack{
            Group{
                Spacer()
                Logo()
                Text("Reset Password")
                    .font(.custom("Markazi Text", size: 44))
                TextField("Email", text: $email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke($authViewModel.showAlert.wrappedValue ? Color.red : Color.clear, lineWidth: 1)
                    )
                VStack{
                    Button{
                        isPressed.toggle()
                        Task {
                            do{
                                try await authViewModel.resetPassword(email: email)
                            }catch{
                                
                            }
                        }
                    }label:{
                        Text("Reset Password")
                    }
                    .buttonStyle(ButtonColor())
                }
                .padding(.top, 20)
                .font(.custom("Karla", size: 18))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
            }
            Spacer()
            Button{
                dismiss()
            } label:{
                Text("go back")
            }
        }
        .offset(y: -30)
        .navigationBarBackButtonHidden(true)
    }
}

extension ForgotPasswordView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains ("@")
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
