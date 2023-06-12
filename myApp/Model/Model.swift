import Foundation

struct MenuList: Decodable {
    let menu: [MenuItem]
}


struct MenuItem: Decodable {
    let id: Int
    let title: String
    let image: String
    let price: String
    let description: String
    let category: String
}

