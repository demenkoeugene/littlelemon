//
//  Home.swift
//  myApp
//
//  Created by Eugene Demenko on 12.06.2023.
//

import SwiftUI

struct Home: View {
    let persistence = PersistenceController.shared
    @Binding var showSignInView: Bool
    var body: some View {
        TabView{
            Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .tabItem {
                    Label("Menu", systemImage: "fork.knife.circle")
                }
            UserProfile(showSignInView: $showSignInView)
                .navigationTitle("Personal Information")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
               
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(showSignInView: .constant(true))
    }
}
