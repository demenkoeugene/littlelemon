//
//  ReservationView.swift
//  myApp
//
//  Created by Eugene Demenko on 21.07.2023.
//

import SwiftUI

struct ReservationView: View {
    @ObservedObject var model: Model
    
    var body: some View {
        // you can create variables inside body
        // to help you reduce code repetition
        let restaurant = model.reservation.restaurant
        let reservationDate = model.reservation.reservationDate
        VStack{
            
            Header()
            NavigationView{
                
                ScrollView {
                    VStack {
                        if restaurant.city.isEmpty {
                            
                            VStack(alignment: .center) {
                                HStack(alignment: .center){
                                    
                                    // if city is empty no reservation has been
                                    // selected yet, so, show the following message
                                    Text("No Reservation Yet")
                                        .foregroundColor(.gray)
                                        .font(.custom("Karla", size: 18))
                                    
                                }
                            }
                            .offset(y: 250)
                        } else {
                            
                            HStack {
                                VStack (alignment: .leading) {
                                    Text("RESTAURANT")
                                        .font(.custom("Markazi Text", size: 28))
                                        .padding(.bottom, 5)
                                    RestaurantView(restaurant)
                                }
                                Spacer()
                            }
                            .frame(maxWidth:.infinity)
                            .padding(.bottom, 20)
                            
                            Divider()
                                .padding(.bottom, 20)
                            
                            
                            VStack {
                                HStack {
                                    Text("NAME: ")
                                        .foregroundColor(.gray)
                                        .font(.custom("Karla", size: 16))
                                    
                                    Text(model.reservation.customerName)
                                        .keyboardType(.default)
                                        .font(.custom("Karla", size: 16))
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("PHONE: ")
                                        .foregroundColor(.gray)
                                        .font(.custom("Karla", size: 16))
                                    
                                    Text(model.reservation.customerPhoneNumber)
                                        .font(.custom("Karla", size: 16))
                                        .keyboardType(.asciiCapableNumberPad)
                                    Spacer()
                                }
                                
                            }
                            .padding(.bottom, 20)
                            
                            
                            HStack {
                                Text("PARTY: ")
                                    .foregroundColor(.gray)
                                    .font(.custom("Karla", size: 16))
                                    .font(.subheadline)
                                
                                Text("\(model.reservation.party)")
                                    .font(.custom("Karla", size: 16))
                                Spacer()
                            }
                            .padding(.bottom, 20)
                            
                            VStack {
                                HStack {
                                    Text("DATE: ")
                                        .foregroundColor(.gray)
                                        .font(.custom("Karla", size: 16))
                                    
                                    Text(reservationDate, style: .date)
                                        .font(.custom("Karla", size: 16))
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("TIME: ")
                                        .foregroundColor(.gray)
                                        .font(.custom("Karla", size: 16))
                                    Text(reservationDate, style: .time)
                                        .font(.custom("Karla", size: 16))
                                    Spacer()
                                }
                            }
                            .padding(.bottom, 20)
                            
                            HStack {
                                VStack (alignment: .leading) {
                                    Text("SPECIAL REQUESTS:")
                                        .foregroundColor(.gray)
                                        .font(.custom("Karla", size: 16))
                                    Text(model.reservation.specialRequests)
                                        .font(.custom("Karla", size: 16))
                                }
                                Spacer()
                            }
                            .frame(maxWidth:.infinity)
                           
                            
                        }
                            
                        
                    }
                    
                }
                .padding(50)
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle("Your Reserved")
                
            }
            .offset(y: -15)
        }
    }
}
struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(model: Model())
    }
}






