//
//  DateServer.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/20/21.
//

import Foundation
import CoreData


class DateServer {
    //MARK: Print functions
    static func printTime(inputTime:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return (formatter.string(from: inputTime))
    }
    
    static func printShortTime(inputTime:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return (formatter.string(from: inputTime))
    }
    
    static func printWeekday(inputTime:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return (formatter.string(from: inputTime))
    }
    
    
    //MARK: Generate time stamp of this week / today
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
    
    static func startOfToday() -> Date {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.yearForWeekOfYear, .month,.day]), from: date)
        let today = calendar.date(from: components)!
        return today
    }
    
    static func startOfToday(date:Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.yearForWeekOfYear, .month,.day]), from: date)
        let today = calendar.date(from: components)!
        return today
    }
    
    static func combineDayTime(day:Date,time:Date) -> Date {
        let calendar = Calendar.current
        var dayComponents = calendar.dateComponents(
            Set<Calendar.Component>([.yearForWeekOfYear, .month,.day]), from: day)
        let timeComponents = calendar.dateComponents(
            Set<Calendar.Component>([.hour, .minute]), from: time)
       
        dayComponents.hour = timeComponents.hour
        dayComponents.minute = timeComponents.minute
        
        let combinedDate = calendar.date(from: dayComponents)!
        return combinedDate
        
    }
    
    //MARK: Functions that generate string arrays for date picker
    
    static func generateDays(offset:Int) -> [Int]{
        var days: [Int] = []
        var date = startOfThisWeek()
        var temdate = Date()
        date = Calendar.current.date(byAdding: .weekOfYear, value: offset, to: date)!
        for r in 0...6 {
            temdate = Calendar.current.date(byAdding: .day, value: r, to: date)!
            let components = Calendar.current.dateComponents([.day], from: temdate)
            days.append(components.day ?? 0)
        }
        return days
    }
    
    static func generateWeekdays(offset:Int) -> [String]{
        var weekdays: [String] = []
        var date = startOfThisWeek()
        var temdate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        date = Calendar.current.date(byAdding: .weekOfYear, value: offset, to: date)!
        for r in 0...6 {
            temdate = Calendar.current.date(byAdding: .day, value: r, to: date)!
            weekdays.append(dateFormatter.string(from: temdate))
        }
        return weekdays
    }
    
    static func generateStartDay (offset:Int) -> String {
        var date = startOfThisWeek()
        date = Calendar.current.date(byAdding: .weekOfYear, value: offset, to: date)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        return dateFormatter.string(from: date)
    }
    
    //MARK: Given week and date offset, generate new date
    //offset:week
    
    static func genrateDateStemp (offset:Int) -> Date {
        var date = startOfThisWeek()
        date = Calendar.current.date(byAdding: .weekOfYear, value: offset, to: date)!
        return date
    }
    
    static func genrateDateStemp (offset:Int, daysOfWeek: Int) -> Date {
        var date = startOfThisWeek()
        date = Calendar.current.date(byAdding: .weekOfYear, value: offset, to: date)!
        date = Calendar.current.date(byAdding: .day, value: daysOfWeek, to: date)!
        return date
    }
    
    static func genrateDateStemp (startOfWeek:Date, daysOfWeek: Int) -> Date {
        var date = startOfWeek
        date = Calendar.current.date(byAdding: .day, value: daysOfWeek, to: date)!
        return date
    }
    
    
    
    static func isSameDay (date1:Date,date2:Date){
        
    }
    
    static func getMinutes(date:Date) -> Int {
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from:date)
        let minutes = calendar.component(.minute, from: date)
        print("date:" + printShortTime(inputTime: date) + ", \(60 * hours + minutes)")
        return (60 * hours + minutes)
    }
    
    //MARK: Add cetain time
    static func addOneWeek (date:Date) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear,value: 1, to: date)!
    }
    
    
    static func addOneDay (date:Date) -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
    
    static func minusOneDay (date:Date) -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: date)!
    }
    
}
