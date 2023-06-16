//
//  FoodMenuList.swift
//  myApp
//
//  Created by Eugene Demenko on 15.06.2023.
//

import SwiftUI

struct FoodMenuList: View{
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
            .padding([.top, .bottom], 10)
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
        
        Divider()
            .padding([.leading, .trailing], 30)
    }
}

