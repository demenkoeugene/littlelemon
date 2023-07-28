//
//  SplashScreenView.swift
//  myApp
//
//  Created by Eugene Demenko on 16.07.2023.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 1.0
    @State private var opacity = 0.5
    
    @EnvironmentObject private var viewModel: AuthViewModel
    @EnvironmentObject private var model: FirestoreManager
    
    var body: some View {
        if isActive{
            Onboarding()
                .environmentObject(viewModel)
        }else{
            VStack{
                VStack{
                    Logo()
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 1.2
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4){
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
        }
        
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
