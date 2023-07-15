//
//  ForgotPasswordView.swift
//  myApp
//
//  Created by Eugene Demenko on 16.07.2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button{
            dismiss()
        } label:{
            Text("return to the login")
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
