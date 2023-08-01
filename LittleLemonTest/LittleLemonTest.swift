//
//  LittleLemonTest.swift
//  LittleLemonTest
//
//  Created by Eugene Demenko on 01.08.2023.
//

import XCTest
@testable import myApp

class FirestoreManagerTests: XCTestCase {
    var firestoreManager: MockFirestoreManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        firestoreManager = MockFirestoreManager()
    }

    override func tearDownWithError() throws {
        firestoreManager = nil
        try super.tearDownWithError()
    }

    // Test the getData(userId:completion:) method
    func testGetData() {
        let userId = "testUserId"
        let mockReservation = Reservation(
            id: "testReservationId",
            restaurant: RestaurantLocation(city: "Test City", neighborhood: "Test Neighborhood", phoneNumber: "Test Phone"),
            customerName: "Test Customer",
            customerPhoneNumber: "Test Phone Number",
            reservationDate: Date(),
            party: 4,
            specialRequests: "Test Special Requests",
            customerId: userId, // Assuming this reservation is associated with the test user
            createReservation: Date()
        )
        firestoreManager.mockReservation = mockReservation

        // Call the getData method with the test userId
        firestoreManager.getData(userId: userId) { reservation in
            // Check if the returned reservation is not nil
            XCTAssertNotNil(reservation, "Reservation should not be nil")

            // Add more assertions based on your expected behavior
            // For example, you can check if the reservation has the correct customer ID, etc.
            XCTAssertEqual(reservation?.id, mockReservation.id, "Reservation IDs should match")
        }
    }


}

// Mock FirestoreManager class
class MockFirestoreManager: FirestoreManager {
    var mockReservations = [Reservation]()
    var mockReservation: Reservation?

    override func getData(userId: String, completion: @escaping (Reservation?) -> Void) {
        completion(mockReservation)
    }

    override func deleteReservation(reservationToDelete: Reservation, userId: String) {
        mockReservations.removeAll { $0.id == reservationToDelete.id }
    }

    override func saveReservationToFirestore(reservation: Reservation, userId: String) {
        mockReservations.append(reservation)
    }
}
