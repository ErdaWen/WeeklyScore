//
//  DateServer.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/19/21.
//

import Foundation
class DateServer{
    static func printTime(inputTime:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return (formatter.string(from: inputTime))
    }
    
    static func startOfThisWeek() -> Date {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.yearForWeekOfYear, .weekOfYear]), from: date)
        let startOfWeek = calendar.date(from: components)!
        return startOfWeek
    }
}
