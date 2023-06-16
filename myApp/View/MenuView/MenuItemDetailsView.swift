//
//  MenuItemDetailsView.swift
//  myApp
//
//  Created by Eugene Demenko on 14.06.2023.
//

import SwiftUI

struct MenuItemDetailsView: View {
    var menuItem: DishEntity
    
    var body: some View {
        List{
            AsyncImage(url: URL(string: menuItem.image!)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding([.top, .leading, .trailing, .bottom], 30)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading){
               
                Text("Description:")
                    .fontWeight(.bold)
                Text(menuItem.descriptionItem ?? "error")
                
            }
            HStack {
                    Text("Price:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(menuItem.price!)$")
            }
            .padding(5)
            
          
        }
        .navigationTitle(menuItem.title!)
        .navigationBarTitleDisplayMode(.large)
    }
    
}

