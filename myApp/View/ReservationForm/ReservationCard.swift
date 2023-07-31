//
//  ReservationCard.swift
//  myApp
//
//  Created by Eugene Demenko on 30.07.2023.
//

import SwiftUI

struct ReservationCard: View {
    @ObservedObject var viewmodelReservation: FirestoreManager
    var restaurant: RestaurantLocation
    var reservationDate: Date
    
    var body: some View{
        Text("Your Reservation")
            .font(.custom("Markazi Text", size: 38))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 30)
        
        ZStack{
            Rectangle()
                .fill(Color("#F4CE14"))
                .cornerRadius(20)
            
            VStack{
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
                        
                        Text(viewmodelReservation.reservation.customerName)
                            .keyboardType(.default)
                            .font(.custom("Karla", size: 16))
                        Spacer()
                    }
                    
                    HStack {
                        Text("PHONE: ")
                            .foregroundColor(.gray)
                            .font(.custom("Karla", size: 16))
                        
                        Text(viewmodelReservation.reservation.customerPhoneNumber)
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
                    
                    Text("\(viewmodelReservation.reservation.party)")
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
                        Text(viewmodelReservation.reservation.specialRequests)
                            .font(.custom("Karla", size: 16))
                    }
                    Spacer()
                }
                .frame(maxWidth:.infinity)
            }
            .padding(30)
        }
    }
}


