//
//  Schedule+CoreDataProperties.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/23/21.
//
//

import Foundation
import CoreData


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var beginTime: Date
    @NSManaged public var checked: Bool
    @NSManaged public var endTime: Date
    @NSManaged public var hidden: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var journal: String?
    @NSManaged public var location: String?
    @NSManaged public var minutesGained: Int64
    @NSManaged public var notes: String?
    @NSManaged public var score: Int64
    @NSManaged public var scoreGained: Int64
    @NSManaged public var statusDefault: Bool
    @NSManaged public var items: Item

}

extension Schedule : Identifiable {

}
