//
//  UserProfile.swift
//  myApp
//
//  Created by Eugene Demenko on 18.07.2023.
//

import SwiftUI



struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var viewModel: AuthManager
   
    
    @State private var showAlert = false
    var body: some View {
       
        
        if let user = viewModel.currentUser {
           
            VStack{
                Header()
                VStack(alignment: .leading){
                    HStack(){
                        if let photoURL = user.photoURL {
                            AsyncImage(url: photoURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            // Show a placeholder or default image when photoURL is nil
                            Text (viewModel.currentUser?.initials ?? "A")
                                .font (.title)
                                .fontWeight (.semibold)
                                .foregroundColor (.white)
                                .frame (width: 80, height: 80)
                                .background (Color (.systemGray3))
                                .clipShape(Circle())
                        }
                        VStack(alignment: .leading) {
                            Text("\(user.fullName)")
                                .font(.custom("Karla", size: 24))
                            Text("\(user.email)")
                                .font(.custom("Karla", size: 14))
                                .foregroundColor(Color("#EDEFEE"))
                        }
                        Spacer()
                        if accessSignInWithGoogle {
                            Button{
                                
                            }label: {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.black)
                            }
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
                    
                    Button("\(Image(systemName: "person.crop.circle.badge.xmark")) Account deletion") {
                        showAlert = true
                    }
                    .listRowSeparator(.hidden)
                    .foregroundColor(.red)
                    .padding([.top, .bottom], 8)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Confirm Account Deletion"),
                            message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                viewModel.userSession = nil
                                viewModel.currentUser = nil
                                viewModel.deleteAccount()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    
                    if accessSignInWithGoogle {
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("\(Image(systemName: "key")) Reset password")
                                .foregroundColor(.red)
                                .padding([.top, .bottom], 8)
                        }
                        .listRowSeparator(.hidden)
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(.clear) // Hides the navigation arrow
                    }
                    
                    Button("\( Image(systemName: "door.left.hand.open")) Log out"){
                        viewModel.signOut()
                    }
                    .listRowSeparator(.hidden)
                    .foregroundColor(.red)
                    .padding([.top, .bottom], 8)
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(.black)
                .font(.custom("Karla", size: 18))
            }
        }
        
        
    }
    
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}

