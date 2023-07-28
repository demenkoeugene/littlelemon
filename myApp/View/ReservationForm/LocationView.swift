//
//  LocationView.swift
//  myApp
//
//  Created by Eugene Demenko on 21.07.2023.
//

import SwiftUI

struct LocationView: View {
    @ObservedObject var model: FirestoreManager
    var body: some View {
        
        VStack {
            Header()
            NavigationView {
                // EmptyView()
                List(model.restaurants, id: \.self) { restaurant in
                    NavigationLink(destination: ReservationForm(restaurant, model: model)) {
                        RestaurantView(restaurant)
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .onDisappear{
                if model.tabBarChanged { return }
                // this changes the phrase from "Select a location"
                // to "RESERVATION"
                model.displayingReservationForm = true
            }
            
            .frame(maxHeight: .infinity)
            
            // SwiftUI has this space between the title and the list
            // that is amost impossible to remove without incurring
            // into complex steps that run out of the scope of this
            // course, so, this is a hack, to bring the list up
            // try to comment this line and see what happens.
            .padding(.top, -10)
            
            // makes the list background invisible, default is gray
            .scrollContentBackground(.hidden)
        }
        
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(model: FirestoreManager())
    }
}
