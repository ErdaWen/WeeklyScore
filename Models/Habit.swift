//
//  Habit.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/3/21.
//

import Foundation

class Habit:Decodable,Identifiable{
    // Contents
    var id:Int
    var durationBased:Bool
    var titleIcon:String
    var title:String
    var defaultScore:Int
    var colorTag:Int
    var hidden:Bool
    
    //Statics
    var entryNum:Int
    var checkedEntryNum:Int
    var scoreTotal:Int
    
    // Duration-based
    var hoursTotal:Double
    
    init(){
        id = 0
        durationBased = true
        titleIcon = ""
        title = "New Habit"
        defaultScore = 5
        colorTag = 0
        hidden = false
        
        //Statics
        entryNum = 0
        checkedEntryNum = 0
        scoreTotal = 0
        
        // Duration-based
        hoursTotal = 0.0
    }
    
    func changeHours (inScoreAdded:Int,inHoursAdded:Double ,inCheckedAdded:Int){
        // This function goes after each entry.changeCompletion
        scoreTotal += inScoreAdded
        hoursTotal += inHoursAdded
        checkedEntryNum += inCheckedAdded
    }
    
    
    func changeProp (inTitleIcon:String, inTitle:String, inDefaultScore:Int, inColorTag:Int){
        titleIcon = inTitleIcon
        title = inTitle
        defaultScore = inDefaultScore
        colorTag = inColorTag
    }
    
    func changeDurationBased (){
        durationBased.toggle()
    }
    
}
