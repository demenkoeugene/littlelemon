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

struct Reservation {
    var restaurant: RestaurantLocation
    var customerName:String
    var customerPhoneNumber:String
    var reservationDate:Date
    var party:Int
    var specialRequests:String
    var id = UUID()
    
    init(restaurant: RestaurantLocation = RestaurantLocation(),
         customerName: String = "",
         customerPhoneNumber: String = "",
         reservationDate:Date = Date(),
         party:Int = 1,
         specialRequests:String = "") {
        self.restaurant = restaurant
        self.customerName = customerName
        self.customerPhoneNumber = customerPhoneNumber
        self.reservationDate = reservationDate
        self.party = party
        self.specialRequests = specialRequests
       
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

extension Reservation {
    func toFirestoreDictionary() -> [String: Any] {
        return [
            "restaurant": restaurant.toFirestoreDictionary(),
            "customerName": customerName,
            "customerPhoneNumber": customerPhoneNumber,
            "reservationDate": reservationDate,
            "party": party,
            "specialRequests": specialRequests,
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
