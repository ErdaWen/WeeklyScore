//
//  CordServer.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/1/21.
//

import Foundation
import SwiftUI

class CordServer {
    static func calculateCord(startTime:Date, endTime:Date, today:Date ,unit:Double, durationBased:Bool) -> (CGFloat, CGFloat){
        let minHeight = 25.0
        let cordOffset = 6.0
        
        var startMin = DateServer.getMinutes(date: startTime)
        var endMin = DateServer.getMinutes(date: endTime)
        
        
        if DateServer.startOfToday(date: startTime) != today
        {
            startMin = 0
        }
        if DateServer.startOfToday(date: endTime) != today {
            endMin = 1440
        }
        
        let startCord = cordOffset + unit * Double(startMin) / 60.0
        let heightCord = max(unit * Double(endMin - startMin) / 60.0, minHeight)
//        print("------------")
//        print("start: \(startTime)")
//        print("end: \(endTime)")
//        print("today: \(today)")
//        print("unit: \(unit)")
//        print("durationBased: \(durationBased)")
//        print("startCord: \(startCord)")
//        print("heightCord: \(heightCord)")
        
        
        if durationBased {
            return (CGFloat(startCord),CGFloat(heightCord))
        }
        else{
            return (CGFloat(startCord-minHeight/2.0),CGFloat(minHeight))
            
        }
    }
    
    static func calculateHeight(startTime:Date, endTime:Date, factor:Double,minHeight:Double,maxHeight:Double) -> CGFloat {
        let totMin = DateServer.getTotMin(beginTime: startTime, endTime: endTime)
        var logHeight = minHeight
        if endTime > startTime {
            logHeight = min(minHeight + max(log2(Double(totMin)/30.0)*factor,0),maxHeight)
        }
        return CGFloat(logHeight)
    }

}
