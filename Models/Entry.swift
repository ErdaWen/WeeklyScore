//
//  Entry.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import Foundation

// time slot structure for Duration based habits

class Entry: Codable,Identifiable {
    var id:Int
    var habitid:Int
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
        id = 0
        habitid = 0
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
    
    func changeCompletion (inscoreGained:Int, inhoursGained:Double, inChecked:Bool){
        // Change entry itself
        scoreGained = inscoreGained
        hoursGained = inhoursGained
        checked = inChecked
        // habit.changeHours should always be called after this function
    }
    
    func changeProp (inHabitid:Int, inScore:Int, inBeginTime:Date, inEndTime:Date)
    {
        habitid = inHabitid
        score = inScore
        beginTime = inBeginTime
        endTime = inEndTime
    }
    
    func complete(){
        self.scoreGained = score
    }
    
}
