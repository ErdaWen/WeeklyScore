//
//  Entry.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import Foundation

// time slot structure for Duration based habits

class Entry_Db: Decodable,Identifiable {
    var id:UUID?
    var habitTitle = ""
    var location:String?
    var notes:String?
    var journal:String?
    var score = 0
    var scoreGained = 0
    var checked = false
    var hidden = false
    
    var beginTime = Date()
    var endTime = Date()
    var hoursGained = 0.0
    
}



class Entry_Hb:Decodable,Identifiable {
    var id:UUID?
    var habitTitle = ""
    var location:String?
    var notes:String?
    var journal:String?
    var score = 0
    var scoreGained = 0
    var checked = false
    var hidden = false
    var timePoint = Date()
}
