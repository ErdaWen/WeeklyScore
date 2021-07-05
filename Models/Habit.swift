//
//  Habit.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/3/21.
//

import Foundation

class Habit:Decodable,Identifiable{
    // Contents
    var id:UUID?
    var durationBased = true
    var titleIcon = ""
    var title = "New Habit"
    var defaultScore = 5
    var colorTag = 0
    var hidden = false
    
    //Statics
    var entryNum = 0
    var checkedEntryNum = 0
    var scoreTotal = 0
    
    // Duration-based
    var hoursTotal:Double
}
