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
                .padding(.top, 10)
                
            VStack(alignment: .leading){
                Text("Your personal information")
                    .font(.custom("Markazi Text", size: 32))
                    .multilineTextAlignment(.leading)
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
                .frame(maxWidth: 350)
            }
            
           
            
            Button("Log out"){
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)//?
                self.presentation.wrappedValue.dismiss()
            }
            .font(.custom("Karla", size: 16))
            .foregroundColor(.red)
            Spacer()
        }
        
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
