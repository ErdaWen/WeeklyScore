//
//  Item+CoreDataProperties.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/18/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var id: Int64
    @NSManaged public var durationBased: Bool
    @NSManaged public var titleIcon: String
    @NSManaged public var title: String
    @NSManaged public var defaultScore: Int64
    @NSManaged public var colorTag: Int64
    @NSManaged public var hidden: Bool
    @NSManaged public var checkedScheduleNum: Int64
    @NSManaged public var scoreTotal: Int64
    @NSManaged public var hoursTotal: Double
    @NSManaged public var schedules: NSSet

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
