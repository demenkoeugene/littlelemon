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
    @State var searchText = ""

   
    
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
            TextField("Search menu", text: $searchText)
                .padding([.leading, .trailing], 30)
            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: buildSortDescriptors()
            ) { (dishes: [DishEntity]) in
              
                    ScrollView {
                        ForEach(dishes) { dish in
                            NavigationLink(destination: MenuItemDetailsView(menuItem: dish)){
                                VStack {
                                    MenuCardView(dish: dish)
                                    Divider()
                                        .padding([.leading, .trailing], 30)
                                }
                               
                            }
                        }
                    }
            }
        }
        .onAppear {
            getMenuData()
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

struct MenuCardView: View{
    var dish: DishEntity

    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text(dish.title!)
                    .font(.custom("Karla", size: 18))
                Text(dish.descriptionItem ?? "error" )
                    .foregroundColor(Color("#495E57"))
                    .padding([.top, .bottom], 2)
                    .multilineTextAlignment(.leading)
                Text("\(dish.price!)$")
                    .foregroundColor(Color("#495E57"))
            }
            .font(.custom("Karla", size: 14))
            Spacer()
            AsyncImage(url: URL(string: dish.image!)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(0)
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
        }
        .foregroundColor(.black)
        .padding([.leading, .trailing], 30)
    }
}


struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}


