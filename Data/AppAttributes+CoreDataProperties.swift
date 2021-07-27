//
//  AppAttributes+CoreDataProperties.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/27/21.
//
//

import Foundation
import CoreData


extension AppAttributes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppAttributes> {
        return NSFetchRequest<AppAttributes>(entityName: "AppAttributes")
    }

    @NSManaged public var nightMode: Bool
    @NSManaged public var weekStartDay: Int64

}

extension AppAttributes : Identifiable {

}
