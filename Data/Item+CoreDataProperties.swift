//
//  Item+CoreDataProperties.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/6/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func itemFetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var checkedTotal: Int64
    @NSManaged public var defaultBeginTime: Date
    @NSManaged public var defaultMinutes: Int64
    @NSManaged public var defaultScore: Int64
    @NSManaged public var durationBased: Bool
    @NSManaged public var hidden: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var lastUse: Date
    @NSManaged public var minutesTotal: Int64
    @NSManaged public var scoreTotal: Int64
    @NSManaged public var title: String
    @NSManaged public var titleIcon: String
    @NSManaged public var defaultReminder: Bool
    @NSManaged public var defaultReminderTime: Int64
    @NSManaged public var schedules: NSSet
    @NSManaged public var tags: Tag

}

// MARK: Generated accessors for schedules
extension Item {

    @objc(addSchedulesObject:)
    @NSManaged public func addToSchedules(_ value: Schedule)

    @objc(removeSchedulesObject:)
    @NSManaged public func removeFromSchedules(_ value: Schedule)

    @objc(addSchedules:)
    @NSManaged public func addToSchedules(_ values: NSSet)

    @objc(removeSchedules:)
    @NSManaged public func removeFromSchedules(_ values: NSSet)

}

extension Item : Identifiable {

}
