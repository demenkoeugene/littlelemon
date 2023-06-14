//
//  DishEntity+CoreDataProperties.swift
//  myApp
//
//  Created by Eugene Demenko on 14.06.2023.
//
//

import Foundation
import CoreData


extension DishEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DishEntity> {
        return NSFetchRequest<DishEntity>(entityName: "Dish")
    }

    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var price: String?
    @NSManaged public var descriptionItem: String?

}

extension DishEntity : Identifiable {

}
