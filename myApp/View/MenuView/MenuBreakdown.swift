//
//  MenuBreakdown.swift
//  myApp
//
//  Created by Eugene Demenko on 16.06.2023.
//

import SwiftUI

struct MenuBreakdown: View{
    @Binding var startersIsEnabled: Bool
    @Binding var mainsIsEnabled: Bool
    @Binding var dessertsIsEnabled: Bool
    @Binding var drinksIsEnabled: Bool
    
    var body: some View{
        Text("ORDER FOR DELIVERY!")
            .font(.custom("Karla", size: 17))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        HStack(spacing: 20) {
            Toggle("Starters", isOn: $startersIsEnabled)
            Toggle("Mains", isOn: $mainsIsEnabled)
            Toggle("Desserts", isOn: $dessertsIsEnabled)
            Toggle("Drinks", isOn: $drinksIsEnabled)
        }
        .toggleStyle(MyToggleStyle())
        .font(.caption)
        .padding(.bottom, 10)
        .toggleStyle(.button)
        .padding(.horizontal)
    }
}

struct MyToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                configuration.label
                    .font(.custom("Karla", size: 16))
            }
        }
        .foregroundColor(Color("#495E57"))
        .padding(5)
        .background {
            if configuration.isOn {
                Color("#495E57").opacity(0.1)
            }
        }
        .cornerRadius(12)
    }
}


