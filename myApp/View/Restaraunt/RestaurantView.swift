//
//  RestaurantView.swift
//  myApp
//
//  Created by Eugene Demenko on 21.07.2023.
//

import SwiftUI

struct RestaurantView: View {
    private var restaurant:RestaurantLocation
    
    init(_ restaurant:RestaurantLocation) {
        self.restaurant = restaurant
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing:3){
            Text(restaurant.city)
                .font(.custom("Markazi Text", size: 32))
                .padding(.bottom, -5)
            HStack {
                Text(restaurant.neighborhood)
                Text("–")
                Text(restaurant.phoneNumber)
            }
            .font(.custom("Karla", size: 14))
            .foregroundColor(.gray)
            
        }
    }
}

struct Restaurant_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRestaurant = RestaurantLocation(city: "Las Vegas", neighborhood: "Downtown", phoneNumber: "(702) 555-9898")
        RestaurantView(sampleRestaurant)
        
    }
    
}


