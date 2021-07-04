//
//  Entry.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import Foundation

// time slot structure for Duration based habits

struct TimeSlot {
    var beginTime = Date()
    var endTime = Date ()
}

class Entry: Decodable {
    private var habitTitle = ""
    private var location = ""
    private var notes = ""
    private var journal = ""
    private var score = 0
    private var scoreGained = 0
    private var checked = false
}

class Entry_Db: Entry {
    private var timeSlot = TimeSlot()
    private var hoursGained = 0.0
}

class Entry_Hb: Entry{
    private var timePoint = Date()
}
