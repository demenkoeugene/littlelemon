//
//  ReservationView.swift
//  myApp
//
//  Created by Eugene Demenko on 21.07.2023.
//

import SwiftUI

struct ReservationView: View {
    @ObservedObject var viewmodelReservation: FirestoreManager
    @ObservedObject var viewModelAuth = AuthManager()
    
    @State private var isLoading = true
    @State private var showOverloadMessage = false // New state variable to control message visibility
    
    var body: some View {
        // you can create variables inside body
        // to help you reduce code repetition
        let restaurant = viewmodelReservation.reservation.restaurant
        let reservationDate = viewmodelReservation.reservation.reservationDate
        
        VStack{
            
            Header()
            ScrollView {
                VStack{
                    if isLoading {
                        ProgressView(showOverloadMessage ? "Overload the page by pulling down" : "Loading") // Show the ProgressView while data is loading
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                            .offset(y: 250)
                    } else if restaurant.city.isEmpty && Date() > reservationDate  {
                        VStack(alignment: .center) {
                            HStack(alignment: .center){
                                Text("No Reservation Yet")
                                    .foregroundColor(.gray)
                                    .font(.custom("Karla", size: 18))
                            }
                        }
                        .offset(y: 250)
                    } else {
                        // Show the ReservationCard only when isLoading is false and appropriate conditions are met
                        ReservationCard(viewmodelReservation: viewmodelReservation, restaurant: restaurant, reservationDate: reservationDate)
                        Button{
                            viewmodelReservation.deleteReservation(reservationToDelete: viewmodelReservation.reservation, userId: viewModelAuth.currentUser?.id ?? "error with getData")
                          
                        } label:{
                            Text("Cancel Reservation")
                                .frame(maxWidth: .infinity)
                                .font(.custom("Karla", size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(20)
                                .padding(.top, 16)
                        }
                    }
                }
                .padding(40)
                
            }
            .offset(y: -15)
            .refreshable {
                viewmodelReservation.getData(userId: viewModelAuth.currentUser?.id ?? "error with getData"){reservations in
                    isLoading = false
                }
            }
            
        }
        .onAppear{
            viewmodelReservation.getData(userId: viewModelAuth.currentUser?.id ?? "error with getData"){reservation in
                isLoading = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if isLoading {
                    showOverloadMessage = true
                }
            }
            
        }
    }
}


struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(viewmodelReservation: FirestoreManager())
    }
}






