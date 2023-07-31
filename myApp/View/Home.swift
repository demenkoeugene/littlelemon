//
//  Home.swift
//  myApp
//
//  Created by Eugene Demenko on 12.06.2023.
//

import SwiftUI

struct Home: View {
    let persistence = PersistenceController.shared
    
    @EnvironmentObject var viewModel: AuthManager
    @StateObject var model = FirestoreManager()
    
    var body: some View {
        NavigationView {
            TabView(selection: $model.tabViewSelectedIndex) {
                Menu()
                    .tag(0)
                    .environment(\.managedObjectContext, persistence.container.viewContext)
                    .tabItem {
                        Label("Menu", systemImage: "fork.knife.circle")
                    }
                
                LocationView(model: model)
                    .tag(2)
                    .tabItem {
                        Label("Locations", systemImage: "fork.knife")
                    }
                ReservationView(viewmodelReservation: model)
                    .tag(3)
                    .tabItem {
                        Label("Reservation", systemImage: "square.and.pencil")
                    }
                UserProfile()
                    .tag(1)
                    .navigationTitle("Personal Information")
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
            .onAppear {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(model: FirestoreManager())
        //            .environmentObject(Model()) // Provide the Model object as an environment object for preview
    }
}
