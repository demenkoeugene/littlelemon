//
//  Menu.swift
//  myApp
//
//  Created by Eugene Demenko on 12.06.2023.
//

import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    

   
    
    var body: some View {
        VStack {
            Text("My Restaurant App")
                .font(.title)
                .padding(.top, 16)
            Text("Location: Chicago")
                .font(.subheadline)
            Text("Welcome to our restaurant app. Explore our menu and place your order.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            FetchedObjects { (dishes: [DishEntity]) in
                    List {
                        ForEach(dishes) { dish in
                            HStack {
                                Text("\(dish.title ?? "") -- \(dish.price ?? "") ")
                                AsyncImage(url: URL(string: dish.image!)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                            }
                        }
                }
            }
        }
        .onAppear {
            getMenuData()
        }
    }
      
    func getMenuData() {
        PersistenceController.shared.clear()
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
                    
                    for menuItem in menuList.menu {
                        let dish = DishEntity(context: viewContext)
                        dish.title = menuItem.title
                        dish.price = menuItem.price
                        dish.image = menuItem.image
                    }
                    try? viewContext.save()
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

