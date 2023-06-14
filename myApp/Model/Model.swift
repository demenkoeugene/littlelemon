import Foundation

struct MenuList: Decodable {
    let menu: [MenuItem]
}


struct MenuItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case title, image, price, descriptionItem = "description"
    }
    let title: String
    let image: String
    let price: String
    let descriptionItem: String
}


