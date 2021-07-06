//
//  Entry.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import Foundation

// time slot structure for Duration based habits

class Entry: Decodable,Identifiable {
    var id:UUID?
    var habitTitle = ""
    var score:Int
    var hidden:Bool
    var beginTime:Date
    var location:String?
    var notes:String?
    var journal:String?
    
    //Statistics
    var scoreGained:Int
    var checked:Bool
    //Duration-based
    var endTime:Date
    var hoursGained:Double
    
    init(){
        habitTitle = "UnkownHabit"
        score = 0
        hidden = false
        beginTime = Date()

        //Statistics
        scoreGained = 0
        checked = false
        //Duration-based
        endTime = Date()
        hoursGained = 0.0
    }
    
    func complete(){
        self.scoreGained = score
    }
}
