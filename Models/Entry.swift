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
    var score = 0
    var hidden = false
    var beginTime = Date()
    var location:String?
    var notes:String?
    var journal:String?
    
    //Statistics
    var scoreGained = 0
    var checked = false
    //Duration-based
    var endTime:Date
    var hoursGained:Double
    
    func complete(){
        scoreGained = score
    }
}
