//
//  ScheduleProperties.swift
//  WeeklyScoreWidgetExtension
//
//  Created by Erda Wen on 8/28/21.
//

import Foundation
import SwiftUI

class ScheduleProperties {
    var beginTime:Date = DateServer.startOfToday() + 32400
    var endTime:Date = DateServer.startOfToday() + 36000
    var durationBased:Bool = true
    var title:String = "📚Study!"
    var score:Int = 5
    var color:Color = Color("tag_color_red")
    var colortext:Color = Color("tag_color_red_text")
}
