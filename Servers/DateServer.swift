//
//  DateServer.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/20/21.
//

import Foundation
import CoreData


class DateServer {
    static func printTime(inputTime:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return (formatter.string(from: inputTime))
    }
    
    static func startOfThisWeek() -> Date {
        var startDay:Int64 = 0
        
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<AppAttributes> = AppAttributes.fetchRequest()
        do{
            let attributes = try managedObjectContext.fetch(fetchRequest)
            startDay = attributes[0].weekStartDay
        } catch {
            print("Cannot get week start day attribute")
            print(error)
        }

        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.yearForWeekOfYear, .weekOfYear]), from: date)
        let thisMonday = calendar.date(from: components)!
        var startOfWeek = Calendar.current.date(byAdding: .day, value: Int(startDay), to: thisMonday)!
        if startOfWeek > date {
            startOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1 , to: startOfWeek)!
        }
        return startOfWeek
    }
}
