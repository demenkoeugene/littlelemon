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
    
    @State var startersIsEnabled = true
    @State var mainsIsEnabled = true
    @State var dessertsIsEnabled = true
    @State var drinksIsEnabled = true
    
    
    @State var isLoaded = false
    @State var searchText = ""
    private var home = Home()
   
    
    var body: some View {
        VStack {
            Spacer()
            Header()
            VStack{
                Hero()
                TextField("\(Image(systemName: "magnifyingglass")) Search menu",
                          text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding([.leading, .trailing, .bottom], 30)
            }
            .background(Color("#495E57"))
            .padding([.bottom], 20)
            
            VStack(alignment: .leading){
                MenuBreakdown(startersIsEnabled: $startersIsEnabled,
                              mainsIsEnabled: $mainsIsEnabled,
                              dessertsIsEnabled: $dessertsIsEnabled,
                              drinksIsEnabled: $drinksIsEnabled)
            }
            .padding([.leading, .trailing], 15)
            Divider()
           
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
        var subpredicates: [NSPredicate] = []
        
        // Search text predicate
        if !searchText.isEmpty {
            let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            subpredicates.append(searchPredicate)
        }
        
        // Category filters
        if !startersIsEnabled {
            let startersPredicate = NSPredicate(format: "category != %@", "starters")
            subpredicates.append(startersPredicate)
        }
        if !mainsIsEnabled {
            let mainsPredicate = NSPredicate(format: "category != %@", "mains")
            subpredicates.append(mainsPredicate)
        }
        if !dessertsIsEnabled {
            let dessertsPredicate = NSPredicate(format: "category != %@", "desserts")
            subpredicates.append(dessertsPredicate)
        }
        if !drinksIsEnabled {
            let drinksPredicate = NSPredicate(format: "category != %@", "drinks")
            subpredicates.append(drinksPredicate)
        }
        
        // Combine subpredicates using AND operator
        return NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
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
                        dish.category = menuItem.category
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


