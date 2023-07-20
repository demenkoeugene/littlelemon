import Foundation

struct MenuList: Decodable {
    let menu: [MenuItem]
}


struct MenuItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case title, image, price, descriptionItem = "description", category
    }
    let title: String
    let image: String
    let price: String
    let descriptionItem: String
    let category: String
}


class Model: ObservableObject {
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
  
  @Published var reservation = Reservation()
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
}


