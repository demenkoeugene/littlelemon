//
//  LittleLemonTest.swift
//  LittleLemonTest
//
//  Created by Eugene Demenko on 01.08.2023.
//

import XCTest

import FirebaseFirestore

@testable import myApp // Replace YourAppTarget with your app's target name

class FirestoreManagerTests: XCTestCase {

    // Define a variable to hold the instance of FirestoreManager
    var firestoreManager: FirestoreManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        firestoreManager = FirestoreManager()
    }

    override func tearDownWithError() throws {
        firestoreManager = nil
        try super.tearDownWithError()
    }

    // Test the getData(userId:completion:) method
    func testGetData() {
        let userId = "testUserId"
        
        // Call the getData method with the test userId
        firestoreManager.getData(userId: userId) { reservation in
            // Check if the returned reservation is not nil
            XCTAssertNotNil(reservation, "Reservation should not be nil")
            
            // Add more assertions based on your expected behavior
            // For example, you can check if the reservation has the correct customer ID, etc.
        }
    }

    // Test the deleteReservation(reservationToDelete:userId:) method
    func testDeleteReservation() {
        // Create a test reservation
        let testReservation = Reservation(
            id: "testReservationId",
            restaurant: RestaurantLocation(city: "Test City", neighborhood: "Test Neighborhood", phoneNumber: "Test Phone"),
            customerName: "Test Customer",
            customerPhoneNumber: "Test Phone Number",
            reservationDate: Date(),
            party: 4,
            specialRequests: "Test Special Requests",
            customerId: "testUserId",
            createReservation: Date()
        )

        // Add the test reservation to the firestoreManager's reservations array
        firestoreManager.reservations = [testReservation]

        // Call the deleteReservation method with the test reservation and userId
        firestoreManager.deleteReservation(reservationToDelete: testReservation, userId: "testUserId")
        
        // Check if the reservation has been removed from the reservations array
        XCTAssertFalse(firestoreManager.reservations.contains(testReservation), "Reservation should be removed")
    }

    // Test the saveReservationToFirestore(reservation:userId:) method
    func testSaveReservationToFirestore() {
        // Create a test reservation
        let testReservation = Reservation(
            id: "testReservationId",
            restaurant: RestaurantLocation(city: "Test City", neighborhood: "Test Neighborhood", phoneNumber: "Test Phone"),
            customerName: "Test Customer",
            customerPhoneNumber: "Test Phone Number",
            reservationDate: Date(),
            party: 4,
            specialRequests: "Test Special Requests",
            customerId: "testUserId",
            createReservation: Date()
        )

        // Call the saveReservationToFirestore method with the test reservation and userId
        firestoreManager.saveReservationToFirestore(reservation: testReservation, userId: "testUserId")

        // Add your own assertions based on the expected behavior of saving a reservation to Firestore
        // For example, you can check if the reservation data exists in the Firestore collection, etc.
    }
}
