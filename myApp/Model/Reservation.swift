//
//  Reservation.swift
//  myApp
//
//  Created by Eugene Demenko on 19.07.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore

struct Reservation: Identifiable {
    @DocumentID var id: String?
    var restaurant: RestaurantLocation
    var customerName:String
    var customerPhoneNumber:String
    var reservationDate: Date
    var party:Int
    var specialRequests:String
    var customerId: String
    var createReservation: Date
    
    init(id: String? = nil,
         restaurant: RestaurantLocation = RestaurantLocation(),
         customerName: String = "",
         customerPhoneNumber: String = "",
         reservationDate:Date = Date(),
         party:Int = 1,
         specialRequests:String = "",
         customerId: String = "",
         createReservation: Date = Date()) {
        self.id = id
        self.restaurant = restaurant
        self.customerName = customerName
        self.customerPhoneNumber = customerPhoneNumber
        self.reservationDate = reservationDate
        self.party = party
        self.specialRequests = specialRequests
        self.customerId = customerId
        self.createReservation = createReservation
    }
    
}

struct RestaurantLocation: Hashable {
    let city:String
    let neighborhood:String
    let phoneNumber:String
    
    init(city:String = "",
         neighborhood:String = "",
         phoneNumber:String = "") {
        self.city = city
        self.neighborhood = neighborhood
        self.phoneNumber = phoneNumber
    }
}
//save 
extension Reservation {
    func toFirestoreDictionary() -> [String: Any] {
        return [
            "restaurant": restaurant.toFirestoreDictionary(),
            "customerName": customerName,
            "customerPhoneNumber": customerPhoneNumber,
            "reservationDate": reservationDate,
            "party": party,
            "specialRequests": specialRequests,
            "customerId": customerId,
            "createReservation": createReservation
        ]
    }
}

extension RestaurantLocation {
    func toFirestoreDictionary() -> [String: Any] {
        return [
            "city": city,
            "neighborhood": neighborhood,
            "phoneNumber": phoneNumber,
        ]
    }
}


