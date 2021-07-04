//
//  Habit.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/3/21.
//

import Foundation

// Parent habit class
class Habit:Decodable{
    var titleIcon = ""
    var title = "New Habit"
    var initialDate = Date()
    var entryNumTotal = 0
    var scoreTotal = 0
    var defaultScore = 5
    var hidden = false
    
}

// Duration-based habit
class Habit_Db:Habit{
    var hoursTotal = 0.0
}

// Hit-based habit
class Habit_Hb:Habit{
    var hitTotal = 0
}
