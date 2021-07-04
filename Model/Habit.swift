//
//  Habit.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/3/21.
//

import Foundation

// Parent habit class
class Habit:Decodable{
    private var titleIcon = ""
    private var title = "New Habit"
    private var initialDate = Date()
    private var entryNumTotal = 0
    private var scoreTotal = 0
    private var defaultScore = 5
    
    func changeTitleIcon(inputIcon:String) -> Bool {
        self.titleIcon = inputIcon
        return true
    }
    
    func changeTitle(inputTitle:String) -> Bool {
        self.title = inputTitle
        return true
    }
}

// Duration-based habit
class Habit_Db:Habit{
    private var hoursTotal = 0.0
}

// Hit-based habit
class Habit_Hb:Habit{
    private var hitTotal = 0
}
