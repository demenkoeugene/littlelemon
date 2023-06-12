//
//  Menu.swift
//  myApp
//
//  Created by Eugene Demenko on 12.06.2023.
//

import SwiftUI

struct Menu: View {
    var body: some View {
        VStack{
            Text("My Restaurant App")
                .font(.title)
                .padding(.top, 16)
            Text("Location: Chicago")
                .font(.subheadline)
            Text("Welcome to our restaurant app. Explore our menu and place your order.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            List {
                // Placeholder list items
                Text("Menu Item 1")
                Text("Menu Item 2")
                Text("Menu Item 3")
                
            }
        }
        
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
