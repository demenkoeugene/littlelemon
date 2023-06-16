//
//  Header.swift
//  myApp
//
//  Created by Eugene Demenko on 16.06.2023.
//

import SwiftUI

struct Header: View {
    var body: some View{
        HStack{
            Image("logo2")
                .padding(.bottom, 10)
        }
    
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
