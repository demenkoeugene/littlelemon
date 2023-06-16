//
//  UserProfile.swift
//  myApp
//
//  Created by Eugene Demenko on 12.06.2023.
//

import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
   
    
    let firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    let lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    let email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    
    var body: some View {
        VStack{
            Header()
                .padding(.top, 10)
            VStack(alignment: .leading){
                HStack(){
                    Image("profile-image-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(180)
                    VStack(alignment: .leading){
                        Text("\(firstName) \(lastName)")
                            .font(.custom("Karla", size: 28))
                        Text("\(email)")
                            .font(.custom("Karla", size: 14))
                            .foregroundColor(Color("#EDEFEE"))
                    }
                    Spacer()
                    Button{
                        
                    }label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: 340)
            }
           
            
           
            List{
                Button("\( Image(systemName: "creditcard")) Payment methods"){
                    
                }
                .listRowSeparator(.hidden)
                .padding([.top, .bottom], 8)
                Button("\( Image(systemName: "tag")) Promo code"){
                    
                }
                .listRowSeparator(.hidden)
                .padding([.top, .bottom], 8)
                Button("\( Image(systemName: "gearshape")) Settings"){
                    
                }
                .listRowSeparator(.hidden)
                .padding([.top, .bottom], 8)
                Button("\( Image(systemName: "info.circle")) About us"){
                    
                }
                .listRowSeparator(.hidden)
                .padding([.top, .bottom], 8)
                Button("\( Image(systemName: "questionmark.circle")) Support"){
                    
                }
                .listRowSeparator(.hidden)
                .padding([.top, .bottom], 8)
                Button("\( Image(systemName: "door.left.hand.open")) Log out"){
                    UserDefaults.standard.set(false, forKey: kIsLoggedIn)//?
                    self.presentation.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
                .padding([.top, .bottom], 8)
            }
            .scrollContentBackground(.hidden)
            .foregroundColor(.black)
            .font(.custom("Karla", size: 18))
        }
        
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
