//
//  Hero.swift
//  myApp
//
//  Created by Eugene Demenko on 15.06.2023.
//

import SwiftUI

struct Hero: View{
    var body: some View{
        HStack(alignment: .center){
            VStack(alignment: .leading){
                Text("Little Lemon")
                    .font(.custom("Markazi Text", size: 40))
                    .foregroundColor(Color("#F4CE14"))
                    .padding(.top, -10)
                Text("Chicago")
                    .foregroundColor(.white)
                    .font(.custom("Markazi Text", size: 28))
                
                Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                    .foregroundColor(.white)
                    .font(.custom("Karla", size: 14))
                    .padding([.trailing], 35)
            }
            .padding([.top],20)
            .padding([.bottom],5)
            
            Image("HeroImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 125, height: 125)
                .cornerRadius(10)
               
        }
        .padding([.leading, .trailing],20)
        .frame(maxHeight: 250)
    }
}

struct Hero_Previews: PreviewProvider {
    static var previews: some View {
        Hero()
    }
}
