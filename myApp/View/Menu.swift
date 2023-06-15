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
  
    @State var isLoaded = false
    @State var searchText = ""
    private var home = Home()
   
    
    var body: some View {
        VStack {
            Spacer()
            VStack{
                Hero()
                TextField("\(Image(systemName: "magnifyingglass")) Search menu", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding([.leading, .trailing, .bottom], 30)
            }
            .background(Color("#495E57"))
            .padding([.bottom], 20)
            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: buildSortDescriptors()
            ) { (dishes: [DishEntity]) in
                ScrollView {
                    ForEach(dishes) { dish in
                        NavigationLink(destination: MenuItemDetailsView(menuItem: dish)){
                            VStack {
                                FoodMenuList(dish: dish)
                            }
                        }
                    }
                }
            }
            

        }
        .onAppear {
            if !isLoaded {
                getMenuData()
                isLoaded = true
            }
        }
        
    }
    
    
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
            return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
    }
    func buildPredicate() -> NSPredicate {
        if !searchText.isEmpty {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        } else {
            return NSPredicate(value: true)
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
                        dish.descriptionItem = menuItem.descriptionItem
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


