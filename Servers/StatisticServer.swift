//
//  StatisticServer.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/13/21.
//

import Foundation

class StatisticServer {
    //Return: TotMin, totCheck, totpoints, complete rate,
    static func goThroughItem(item:Item) -> (Int64,Int64,Int64,Double?,[Date],[Int]){
        var minTot:Int64 = 0
        var minPlaned:Int64 = 0
        var checkTot:Int64 = 0
        var ptsTot:Int64 = 0
        var rate:Double? = nil
        var dates:[Date] = []
        var value:[Int] = []
        var noSchedule = true
        
        let schedules:[Schedule] = Array(item.schedules as! Set<Schedule>)
        var maxDate = Date.init(timeIntervalSince1970: 0)
        if schedules.count == 0 {
            return (minTot,checkTot,ptsTot,rate,dates,value)
            
        }
        
        // calculate total min score checked
        for schedule in schedules{
            if schedule.beginTime < Date(){
                // Standard: for !duration based, find the latest checked>0
                if (!item.durationBased) && (schedule.beginTime > maxDate) && (schedule.checked) {
                    maxDate = schedule.beginTime
                    noSchedule = false
                }
                // Standard: for duration based, find the latest minGain>0
                if (item.durationBased) && (schedule.beginTime > maxDate) && (schedule.minutesGained > 0) {
                    maxDate = schedule.beginTime
                    noSchedule = false
                }
                
                minTot += schedule.minutesGained
                checkTot += (schedule.checked ? 1 : 0)
                ptsTot += schedule.scoreGained
                minPlaned += DateServer.getTotMin(beginTime: schedule.beginTime, endTime: schedule.endTime)
            }
        }// end for
        
        // calculate rate
        if item.durationBased {
            rate = (minPlaned == 0) ? nil : (Double(minTot) / Double(minPlaned))
        } else {
            rate = Double(checkTot) / Double(schedules.count)
        }
        
        if noSchedule{
            return (minTot,checkTot,ptsTot,rate,dates,value)
        }
        
        // calculate date/value for each week
        var tempDate = DateServer.startOfThisWeek(date: maxDate)
        for _ in 0...5 {
            var tempValue:Int64 = 0
            for schedule in schedules {
                if (schedule.beginTime >= tempDate) && (schedule.beginTime < DateServer.addOneWeek(date: tempDate)){
                    if item.durationBased{
                        tempValue += schedule.minutesGained
                    } else {
                        tempValue += schedule.checked ? 1 : 0
                    }
                }
            }
            dates.insert(tempDate, at: 0)
            value.insert(Int(tempValue), at: 0)
            tempDate = DateServer.minusOneWeek(date: tempDate)
        }
        
        return (minTot,checkTot,ptsTot,rate,dates,value)
    }
}
