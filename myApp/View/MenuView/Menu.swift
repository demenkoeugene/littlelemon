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
    //    private var home = Home()
    
    
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
                predicate: MenuHelpers.buildPredicate(searchText: searchText,
                                                      startersIsEnabled: startersIsEnabled,
                                                      mainsIsEnabled: mainsIsEnabled,
                                                      dessertsIsEnabled: dessertsIsEnabled,
                                                      drinksIsEnabled: drinksIsEnabled),
                sortDescriptors: MenuHelpers.buildSortDescriptors()
            )  { (dishes: [DishEntity]) in
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
                MenuHelpers.getMenuData(viewContext: viewContext)
                isLoaded = true
            }
        }
        
    }
}






struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}


