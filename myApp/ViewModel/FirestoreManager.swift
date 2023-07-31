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
    
    func getData(userId: String, completion: @escaping (Reservation?) -> Void) {
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
                            id: document.documentID,
                            restaurant: restaurantLocation,
                            customerName: document["customerName"] as? String ?? "",
                            customerPhoneNumber: document["customerPhoneNumber"] as? String ?? "",
                            reservationDate: (document["reservationDate"] as? Timestamp)?.dateValue() ?? Date(),
                            party: document["party"] as? Int ?? -1,
                            specialRequests: document["specialRequests"] as? String ?? "",
                            customerId: document["customerId"] as? String ?? "",
                            createReservation: (document["createReservation"] as? Timestamp)?.dateValue() ?? Date()
                        )
                        
                    }
                    
                    // Here, you have an array of `Reservation` objects created from the Firestore documents
                    print("Fetched \(reservations.count) reservations.")
                    self.reservations = reservations
                    
                    // Filter the reservations to only those that were booked by the user
                    let filteredReservations = self.reservations.filter { $0.customerId == userId }
                    
                    if let lastReservation = filteredReservations.sorted(by: { $0.createReservation > $1.createReservation }).first {
                        self.reservation = lastReservation
                        print("Here reservation \(lastReservation)")
                    } else {
                        // If no reservations were found, set the reservation to an empty Reservation object
                        self.reservation = Reservation()
                    }
                    
                    DispatchQueue.main.async {
                        completion(self.reservation) // Call completion on the main queue with the last reservation or an empty Reservation object
                    }
                    
                    
                    
                }
            }
        }
    }
    
    
    func deleteReservation(reservationToDelete: Reservation, userId: String) {
        // Get a reference to the database
        let db = Firestore.firestore()
        let reservationsCollection = db.collection("reservations")
        
        reservationsCollection.document(reservationToDelete.id ?? "error").delete() { [self] err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                getData(userId: userId) { reservation in
                    print("Reloading after removed!")
                }
            }
        }
    }
    
    
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
    
    
    
 
}

