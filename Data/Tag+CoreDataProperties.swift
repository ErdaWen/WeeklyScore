//
//  Tag+CoreDataProperties.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/25/21.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func tagFetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var colorName: String
    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var lastUse: Date
    @NSManaged public var items: NSSet

}

// MARK: Generated accessors for items
extension Tag {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Tag : Identifiable {

}
