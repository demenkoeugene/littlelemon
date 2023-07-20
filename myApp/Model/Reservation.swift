//
//  Reservation.swift
//  myApp
//
//  Created by Eugene Demenko on 19.07.2023.
//

import Foundation

struct Reservation {
  var restaurant:RestaurantLocation
  var customerName:String
  var customerEmail:String
  var customerPhoneNumber:String
  var reservationDate:Date
  var party:Int
  var specialRequests:String
  var id = UUID()
  
  init(restaurant:RestaurantLocation = RestaurantLocation(),
       customerName: String = "",
       customerEmail: String = "",
       customerPhoneNumber: String = "",
       reservationDate:Date = Date(),
       party:Int = 1,
       specialRequests:String = "") {
    self.restaurant = restaurant
    self.customerName = customerName
    self.customerEmail = customerEmail
    self.customerPhoneNumber = customerPhoneNumber
    self.reservationDate = reservationDate
    self.party = party
    self.specialRequests = specialRequests
  }
  
}

struct RestaurantLocation:Hashable {
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
