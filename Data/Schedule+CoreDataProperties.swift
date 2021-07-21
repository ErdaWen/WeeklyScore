//
//  Schedule+CoreDataProperties.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/20/21.
//
//

import Foundation
import CoreData


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var scoreGained: Int64
    @NSManaged public var score: Int64
    @NSManaged public var notes: String?
    @NSManaged public var minutesGained: Int64
    @NSManaged public var location: String?
    @NSManaged public var journal: String?
    @NSManaged public var id: UUID?
    @NSManaged public var hidden: Bool
    @NSManaged public var endTime: Date
    @NSManaged public var checked: Bool
    @NSManaged public var beginTime: Date
    @NSManaged public var items: NSSet

}

// MARK: Generated accessors for items
extension Schedule {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Schedule : Identifiable {

}
