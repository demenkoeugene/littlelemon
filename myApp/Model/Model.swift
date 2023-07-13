import Foundation

struct MenuList: Decodable {
    let menu: [MenuItem]
}


struct MenuItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case title, image, price, descriptionItem = "description", category
    }
    let title: String
    let image: String
    let price: String
    let descriptionItem: String
    let category: String
}


struct UserModel: Identifiable, Codable{
    let id: String
    let fullName: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter ( )
        if let components = formatter.personNameComponents (from: fullName) {
            formatter.style = .abbreviated
            return formatter.string (from: components)
        }
        return ""
    }
}


extension UserModel{
    static var MOCK_USER = UserModel(id: NSUUID().uuidString, fullName: "Karla Greate", email: "test@gmail.com")
}
