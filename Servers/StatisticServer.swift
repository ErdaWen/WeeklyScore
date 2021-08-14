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
        var checkTot:Int64 = 0
        var ptsTot:Int64 = 0
        var rate:Double? = nil
        var dates:[Date] = []
        var value:[Int] = []
        let schedules:[Schedule] = Array(item.schedules as! Set<Schedule>)
        var maxDate = Date.init(timeIntervalSince1970: 0)
        for schedule in schedules{
            if schedule.beginTime > maxDate{
                maxDate = schedule.beginTime
            }
            minTot += schedule.minutesGained
            checkTot += (schedule.checked ? 1 : 0)
            ptsTot += schedule.scoreGained
        }
        
        return (minTot,checkTot,ptsTot,rate,dates,value)
    }
}
