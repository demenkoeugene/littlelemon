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
            Image("logo2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 50)
            
            Text("Personal information")
                .font(.custom("Markazi Text", size: 30))
                .multilineTextAlignment(.leading)
            Spacer()
            HStack{
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
            }
            Button("Log out"){
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)//?
                self.presentation.wrappedValue.dismiss()
            }
            .font(.custom("Karla", size: 24))
            .foregroundColor(.white)
            .background(Color("#F4CE14"))
            .cornerRadius(10)
            .frame(width: 300, height: 50)
            Spacer()
        }
        
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
