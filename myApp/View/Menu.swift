//
//  Menu.swift
//  myApp
//
//  Created by Eugene Demenko on 12.06.2023.
//

import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    
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
        .onAppear {
            getMenuData()
        }
        
    }
    
    func getMenuData() {
        let serverURLString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: serverURLString)
        guard let url = url else {
            print("Invalid server URL")
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                do {
                    let decoder = JSONDecoder()
                    let menuList = try decoder.decode(MenuList.self, from: data)
                } catch {
                    print("Error decoding menu data: \(error)")
                }
            }
        }
        task.resume()
    }
    
    
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
