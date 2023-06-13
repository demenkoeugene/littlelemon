import Foundation

struct MenuList: Decodable {
    let menu: [MenuItem]
}


struct MenuItem: Decodable {
    let title: String
    let image: String
    let price: String
}

