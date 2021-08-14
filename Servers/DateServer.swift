//
//  DateServer.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/20/21.
//

import Foundation

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
    
    static func printDate(inputTime:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return (formatter.string(from: inputTime))
    }
    
    static func printWeekday(inputTime:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return (formatter.string(from: inputTime))
    }
    
    
    //MARK: Generate time stamp of this week / today
    static func startOfThisWeek() -> Date {
        let startDay = UserDefaults.standard.integer(forKey: "weekStartDay")
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
    
    static func startOfThisWeek(date:Date) -> Date {
        let startDay = UserDefaults.standard.integer(forKey: "weekStartDay")
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
    
    static func getMinutes(date:Date) -> Int {
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from:date)
        let minutes = calendar.component(.minute, from: date)
        return (60 * hours + minutes)
    }
    
    // Different from getMinnutes(endDate) - getMinnutes(startDate)
    // This function considers the absolute interval of minutes
    // so day-time saving will not be an issue
    static func getTotMin(beginTime:Date,endTime:Date) -> Int64 {
        return Int64((endTime.timeIntervalSinceReferenceDate - beginTime.timeIntervalSinceReferenceDate)/60)
    }
    
    
    //MARK: Add cetain time
    static func addOneWeek (date:Date) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear,value: 1, to: date)!
    }
    
    static func minusOneWeek (date:Date) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear,value: -1, to: date)!
    }
    
    static func addOneDay (date:Date) -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
    
    static func minusOneDay (date:Date) -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: date)!
    }
    
    //MARK: Describe day / week / min
    
    static func describeDay (date:Date) -> (String,Bool){
        let today = startOfToday()
        var isToday = false
        var description = printWeekday(inputTime: date)
        if date == today {
            isToday = true
            description = "Today"
        } else if date == minusOneDay(date: today) {
            description = "Yesterday"
        } else if date == addOneDay(date: today) {
            description = "Tommorrow"
        }
        return(description,isToday)
    }
    
    static func describeWeek (offset:Int) -> String {
        var description = "Week of "+generateStartDay(offset: offset)
        if offset == 0{
            description = "This Week"
        }
        return description
    }
    
    static func describeWeekLite (date:Date) -> String {
        if date == startOfThisWeek(){
            return ("T. W.")
        }
        let description = printDate(inputTime: date)
        return description
    }
    
    static func describeMin(min:Int) -> String {
        var description = ""
        let minutes = min % 60
        let hours = Int ((Double(min)/60.0).rounded(.down))
        if hours == 0 {
            description = "\(minutes) min"
        } else if hours < 100 {
            description = "\(hours) h \(minutes) m"
        } else {
            description = "\(hours) h"
        }
        return description
    }
    
    static func describeMinR(min:Int) -> String {
        var description = ""
        let minutes = min % 60
        let hours = Int ((Double(min)/60.0).rounded(.down))
        if hours == 0 {
            description = "\(minutes) min"
        } else if hours < 100 {
            description = "\(hours) h\r\(minutes) m"
        } else {
            description = "\(hours) h"
        }
        return description
    }

}
