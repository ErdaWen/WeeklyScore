//
//  FakeScheduleProperitesData.swift
//  WeeklyScoreWidgetExtension
//
//  Created by Erda Wen on 8/30/21.
//

import Foundation
import SwiftUI

class FakeScheduleProperitesData {
    let fakeData:[ScheduleProperties]
    init(){
        var fackDataTemp:[ScheduleProperties] = []
        let newSchedule = ScheduleProperties()
        newSchedule.beginTime = DateServer.startOfToday() + 25200
        newSchedule.endTime = DateServer.startOfToday() + 25200
        newSchedule.durationBased = false
        newSchedule.title = "☀️ Get up!"
        newSchedule.score = 5
        newSchedule.color = Color("tag_color_red")
        newSchedule.colortext = Color("tag_color_red_text")
        fackDataTemp.append(newSchedule)
        
        let newSchedule2 = ScheduleProperties()
        newSchedule2.beginTime = DateServer.startOfToday() + 28800
        newSchedule2.endTime = DateServer.startOfToday() + 32400
        newSchedule2.durationBased = true
        newSchedule2.title = "🗞 Read papers!"
        newSchedule2.score = 10
        newSchedule2.color = Color("tag_color_blue")
        newSchedule2.colortext = Color("tag_color_blue_text")
        fackDataTemp.append(newSchedule2)
        
        let newSchedule3 = ScheduleProperties()
        newSchedule3.beginTime = DateServer.startOfToday() + 50400
        newSchedule3.endTime = DateServer.startOfToday() + 52200
        newSchedule3.durationBased = true
        newSchedule3.title = "💪 Work out!"
        newSchedule3.score = 10
        newSchedule3.color = Color("tag_color_red")
        newSchedule3.colortext = Color("tag_color_red_text")
        fackDataTemp.append(newSchedule3)
        
        let newSchedule4 = ScheduleProperties()
        newSchedule4.beginTime = DateServer.startOfToday() + 68400
        newSchedule4.endTime =  DateServer.startOfToday() + 72000
        newSchedule4.durationBased = true
        newSchedule4.title = "🇲🇽 Learn Spanish!"
        newSchedule4.score = 5
        newSchedule4.color = Color("tag_color_green")
        newSchedule4.colortext = Color("tag_color_green_text")
        fackDataTemp.append(newSchedule4)
        
        fakeData = fackDataTemp
    }
}
