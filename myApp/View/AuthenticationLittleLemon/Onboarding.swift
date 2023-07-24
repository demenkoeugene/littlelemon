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
   
//    @StateObject var model = Model()
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        
        NavigationStack{
            VStack {
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


struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            Onboarding()
        }
    }
}
