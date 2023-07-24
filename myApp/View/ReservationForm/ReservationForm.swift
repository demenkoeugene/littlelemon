//
//  ReservationForm.swift
//  myApp
//
//  Created by Eugene Demenko on 21.07.2023.
//

import SwiftUI


struct ReservationForm: View {
    @ObservedObject var model:Model
    @State var showFormInvalidMessage = false
    @State var errorMessage = ""
    
    private var restaurant:RestaurantLocation
    @State var reservationDate = Date()
    @State var party:Int = 1
    @State var specialRequests:String = ""
    @State var customerName = ""
    @State var customerPhoneNumber = ""
    @State var customerEmail = ""
    
    
    // this environment variable stores the presentation mode status
    // of this view. This will be used to dismiss this view when
    // the user taps on the RESERVE
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // stores a temporary reservation used by this view
    @State private var temporaryReservation = Reservation()
    
    // this flag will trigger .onChange
    // this is necessary because due to to a SwiftUI limitation, we cannot change the model
    // values from withing the view itself, as it is being drawn (inside the button)
    // so, this flag will defer the change
    @State var mustChangeReservation = false
    
    init(_ restaurant: RestaurantLocation, model: Model) {
        self.restaurant = restaurant
        self.model = model // Pass the Model object to the initializer
    }
    
    var body: some View {
        VStack {
            NavigationStack{
                Spacer()
                    .frame(height: 50)
                Form {
                    
                    // Restaurant information
                    RestaurantView(restaurant)
                    
                    // shows the party information
                    VStack {
                        VStack (alignment: .leading) {
                            
                            Stepper("Party for \(party)", value: $party, in: 0...12)
                                .font(.custom("Karla", size: 16))
                                .onChange(of: party) { value in
                                    if value == 0 { party = 1}
                                }
                        }
                        
                        
                        // DATE PICKER
                        VStack {
                            HStack{
                                // This shows the date picker
                                // the option in:Date()... allows any date to be
                                // selected from today forward.
                                // if the option was in:...Date(), any date from the past up
                                // to today could be selected
                                //
                                // displayedComponents specify that date and time must be displayed
                                Text("Data: ")
                                    .font(.custom("Karla", size: 16))
                                DatePicker(selection: $reservationDate, in: Date()...,
                                           displayedComponents: [.date, .hourAndMinute]) {
                                    //              Text("Select a date")
                                }
                                           .font(.custom("Karla", size: 16))
                            }
                        }
                    }
                    
                    .padding([.top, .bottom], 20)
                    
                    
                    
                    // Textfields showing informations like customer
                    // name, phone, email, and special requests
                    Group{
                        Group{
                            HStack{
                                Text("NAME: ")
                                    .font(.custom("Karla", size: 16))
                                TextField("Your name...", text: $customerName)
                                    .font(.custom("Karla", size: 16))
                                
                            }
                            
                            HStack{
                                Text("PHONE: ")
                                    .font(.custom("Karla", size: 16))
                                
                                TextField("Your phone number...",
                                          text: $customerPhoneNumber)
                                .font(.custom("Karla", size: 16))
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)
                            }
                            
                            HStack(alignment: .center){
                                TextField("add any special request (optional)",
                                          text: $specialRequests,
                                          axis:.vertical)
                                .padding(.leading, 5)
                                .font(.custom("Karla", size: 16))
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray.opacity(0.2))
                                    .frame(width: 300 ,height: 50))
                                .lineLimit(6)
                                .frame(width: 300 ,height: 50)
                                .padding([.top, .bottom], 10)
                            }
                            .frame(width: 400)
                        }
                        
                        HStack(alignment: .center){
                            
                            Button(action: {
                                validateForm()
                            }, label: {
                                Text("Confirm Reservation")
                            })
                            .buttonStyle(ButtonColorForConfirm())
                        }
                        .frame(width: 400)
                    }
                    Spacer()
                }
                .scrollContentBackground(.hidden)
                
                
                // Forms have this space between the title and the content
                // that is amost impossible to remove without incurring
                // into complex steps that run out of the scope of this
                // course. So, this is a hack, to bring the content up
                // try to comment this line and see what happens.
                .onChange(of: mustChangeReservation) { _ in
                    model.reservation = temporaryReservation
                }
                
                // add an alert after this line
                .alert("ERROR", isPresented: $showFormInvalidMessage, actions: {
                    Button("OK", role: .cancel) { }
                }, message: {
                    Text(self.errorMessage)
                })
            }
        }
        .navigationBarTitle("Reservation")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    
    
    private func validateForm() {
        // customerName must contain just letters
        let nameIsValid = isValid(name: customerName)
        
        guard nameIsValid
        else {
            var invalidNameMessage = ""
            if customerName.isEmpty || !isValid(name: customerName) {
                invalidNameMessage = "Names can only contain letters and must have at least 3 characters\n\n"
            }
            
            var invalidPhoneMessage = ""
            if customerEmail.isEmpty {
                invalidPhoneMessage = "The phone number cannot be blank.\n\n"
            }
            
            
            self.errorMessage = "Found these errors in the form:\n\n \(invalidNameMessage)\(invalidPhoneMessage)"
            
            showFormInvalidMessage.toggle()
            return
        }
        
        // form is valid, proceed
        
        // create new temporary reservation
        let temporaryReservation = Reservation(restaurant:restaurant,
                                               customerName: customerName,
                                               customerPhoneNumber: customerPhoneNumber,
                                               reservationDate:reservationDate,
                                               party:party,
                                               specialRequests:specialRequests)
        
        // Store the temporary reservation locally
        self.temporaryReservation = temporaryReservation
        
        // set the flag to defer changing to the model (see .onChange)
        self.mustChangeReservation.toggle()
        
        // dismiss this view
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func isValid(name: String) -> Bool {
        guard !name.isEmpty,
              name.count > 2
        else { return false }
        for chr in name {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr == " ") ) {
                return false
            }
        }
        return true
    }
    
    
    
}

struct ButtonColorForConfirm: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Karla", size: 20))
            .frame(width: 280, height: 30)
            .foregroundColor(configuration.isPressed ? .black : .white)
            .padding(10)
            .background(configuration.isPressed ? Color("#F4CE14") : Color("#495E57"))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

struct ReservationForm_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRestaurant = RestaurantLocation(city: "Las Vegas", neighborhood: "Downtown", phoneNumber: "(702) 555-9898")
        ReservationForm(sampleRestaurant, model: Model())
    }
}









