//
//  ReservationViewModel.swift
//  myApp
//
//  Created by Eugene Demenko on 26.07.2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FirestoreManager: ObservableObject{
    @Published var reservations = [Reservation]()
    @Published var reservation: Reservation = Reservation()
    let restaurants = [
        RestaurantLocation(city: "Las Vegas",
                           neighborhood: "Downtown",
                           phoneNumber: "(702) 555-9898"),
        RestaurantLocation(city: "Los Angeles",
                           neighborhood: "North Hollywood",
                           phoneNumber: "(213) 555-1453"),
        RestaurantLocation(city: "Los Angeles",
                           neighborhood: "Venice",
                           phoneNumber: "(310) 555-1222"),
        RestaurantLocation(city: "Nevada",
                           neighborhood: "Venice",
                           phoneNumber: "(725) 555-5454"),
        RestaurantLocation(city: "San Francisco",
                           neighborhood: "North Beach",
                           phoneNumber: "(415) 555-1345"),
        RestaurantLocation(city: "San Francisco",
                           neighborhood: "Union Square",
                           phoneNumber: "(415) 555-9813")
    ]
    
    @Published var displayingReservationForm = false
    @Published var temporaryReservation = Reservation()
    @Published var followNavitationLink = false
    
    @Published var displayTabBar = true
    @Published var tabBarChanged = false
    @Published var tabViewSelectedIndex = Int.max {
        didSet {
            tabBarChanged = true
        }
    }
    
    func getData(userId: String) {
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Query the reservations collection
        db.collection("reservations").getDocuments { snapshot, error in
            if let error = error {
                // Handle errors
                print("Error getting reservations: \(error)")
            } else {
                // No errors
                if let snapshot = snapshot {
                    // Get all the documents and create a `Reservation` object for each one
                    let reservations = snapshot.documents.compactMap { document -> Reservation? in
                        
                        guard let restaurantInfo = document["restaurant"] as? [String: Any],
                              let city = restaurantInfo["city"] as? String,
                              let neighborhood = restaurantInfo["neighborhood"] as? String,
                              let phoneNumber = restaurantInfo["phoneNumber"] as? String else {
                            // Return nil if the required fields for restaurant location are missing
                            return nil
                        }
                        let restaurantLocation = RestaurantLocation(city: city,
                                                                    neighborhood: neighborhood,
                                                                    phoneNumber: phoneNumber)
                        return Reservation(
                            restaurant: restaurantLocation,
                            customerName: document["customerName"] as? String ?? "",
                            customerPhoneNumber: document["customerName"] as? String ?? "",
                            reservationDate: document["reservationDate"] as? Date ?? Date(),
                            party: document["party"] as? Int ?? -1,
                            specialRequests: document["specialRequests"] as? String ?? "",
                            customerId: document["customerId"] as? String ?? "",
                            createReservation: document["createReservation"] as? Date ?? Date()
                        )
                    }
                    
                    // Here, you have an array of `Reservation` objects created from the Firestore documents
                    print("Fetched \(reservations.count) reservations.")
                    self.reservations = reservations
                    
                    
                    // Filter the reservations to only those that were booked by the user
                    let filteredReservations = reservations.filter { $0.customerId == userId }
                    
                    
                    let sortedReservations = filteredReservations.sorted(by: { $0.createReservation > $1.createReservation })
                    
                    // Set the `resviewmodel.reservation` property to the first element (latest) in the sorted array
                    if let latestReservation = sortedReservations.first {
                        self.reservation = latestReservation
                        print("Here reservation \(latestReservation)")
                    }
                }
            }
        }
    }
    
    
    
    //    func reload() {
    //        // This will trigger the `objectWillChange.send()` method, which will update the view
    //        self.reservations = []
    //        getData()
    //    }
    
    
    
    func saveReservationToFirestore(reservation: Reservation, userId: String) {
        let db = Firestore.firestore()
        let reservationsCollection = db.collection("reservations")
        
        // Generate a unique document ID for the reservation
        let reservationId = UUID().uuidString
        
        // Create a dictionary of the reservation data
        var reservationData = reservation.toFirestoreDictionary()
        reservationData["customerId"] = userId
        reservationData["createReservation"] = Date()
        
        // Add the reservation data to the Firestore database
        reservationsCollection.document(reservationId).setData(reservationData) { error in
            if let error = error {
                print("Error saving reservation to Firestore: \(error)")
            } else {
                print("Reservation saved to Firestore")
            }
        }
    }
    
    
    func deleteReservation(reservationToDelete: Reservation) {
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Specify the document to delete
        let reservationId = reservationToDelete.id.uuidString
        db.collection("reservations").document(reservationId).delete { error in
            
            // Check for errors
            if error == nil {
                // No errors
                
                // Update the UI from the main thread
                DispatchQueue.main.async {
                    
                    // Remove the reservation that was just deleted
                    self.reservations.removeAll { reservation in
                        
                        // Check for the reservation to remove
                        return reservation.id.uuidString == reservationId
                    }
                }
                
                
            }
        }
        
    }
    
    func updateReservation(reservationToUpdate: Reservation) {
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Set the data to update
        let updatedReservationData = reservationToUpdate.toFirestoreDictionary()
        db.collection("reservations").document(reservationToUpdate.id.uuidString).setData(updatedReservationData, merge: true) { error in
            // Check for errors
            if error == nil {
                // Get the new data
                //                self.getData()
            }
        }
    }
}

//
//class ReservationViewModel: ObservableObject {
//    let restaurants = [
//        RestaurantLocation(city: "Las Vegas",
//                           neighborhood: "Downtown",
//                           phoneNumber: "(702) 555-9898"),
//        RestaurantLocation(city: "Los Angeles",
//                           neighborhood: "North Hollywood",
//                           phoneNumber: "(213) 555-1453"),
//        RestaurantLocation(city: "Los Angeles",
//                           neighborhood: "Venice",
//                           phoneNumber: "(310) 555-1222"),
//        RestaurantLocation(city: "Nevada",
//                           neighborhood: "Venice",
//                           phoneNumber: "(725) 555-5454"),
//        RestaurantLocation(city: "San Francisco",
//                           neighborhood: "North Beach",
//                           phoneNumber: "(415) 555-1345"),
//        RestaurantLocation(city: "San Francisco",
//                           neighborhood: "Union Square",
//                           phoneNumber: "(415) 555-9813")
//    ]
//    
//    @Published var reservation: Reservation = Reservation()
//    @Published var displayingReservationForm = false
//    @Published var temporaryReservation = Reservation()
//    @Published var followNavitationLink = false
//    
//    @Published var displayTabBar = true
//    @Published var tabBarChanged = false
//    @Published var tabViewSelectedIndex = Int.max {
//        didSet {
//            tabBarChanged = true
//        }
//    }
//}
