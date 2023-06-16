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
                Text("ORDER FOR DELIVERY!")
                    .font(.custom("Karla", size: 17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                HStack(spacing: 20) {
                    Toggle("Starters", isOn: $startersIsEnabled)
                    Toggle("Mains", isOn: $mainsIsEnabled)
                    Toggle("Desserts", isOn: $dessertsIsEnabled)
                    Toggle("Drinks", isOn: $drinksIsEnabled)
                }
                .toggleStyle(MyToggleStyle())
                .font(.caption)
                .padding(.bottom, 10)
                .toggleStyle(.button)
                .padding(.horizontal)
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


struct Header: View {
    var body: some View{
        HStack{
            Image("logo2")
                .padding(.bottom, 10)
        }
    
    }
}


struct MyToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                configuration.label
                    .font(.custom("Karla", size: 16))
            }
        }
        .foregroundColor(Color("#495E57"))
        .padding(5)
        .background {
            if configuration.isOn {
                Color("#495E57").opacity(0.1)
            }
        }
        .cornerRadius(12)
    }
}


struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}


