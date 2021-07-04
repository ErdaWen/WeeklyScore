//
//  Entry.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import Foundation

// time slot structure for Duration based habits

class TimeSlot {
    var beginTime = Date()
    var endTime = Date ()
}

class Entry: Decodable {
    var habitTitle = ""
    var location:String?
    var notes:String?
    var journal:String?
    var score = 0
    var scoreGained = 0
    var checked = false
    var hidden = false
}

class Entry_Db: Entry {
    var timeSlot = TimeSlot()
    var hoursGained = 0.0
}

class Entry_Hb: Entry{
    var timePoint = Date()
}
