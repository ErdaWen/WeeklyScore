//
//  ScheduleView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI
import UIKit

struct ScheduleView: View {
    
    // Environment
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    // week offset
    @State var weekFromNow = 0
    // day offset
    @State var dayFromDay1 = -1
    
    // String arrays for title and day picker dispaly
    @State var dayNumbers:[Int] = [1, 2, 3, 4, 5, 6, 7]
    @State var weekdayNumbers:[String] = ["Mon", "Tue", "Wed", "Thr", "Fri", "Sat", "Sun"]
    @State var previewMode = UserDefaults.standard.bool(forKey: "previewMode")
    
    // appearence related
    let mTitle:CGFloat = 20
    let hTitle:CGFloat = 38
    let mPicker:CGFloat = 40
    let hPicker:CGFloat = 45
    let minDragDist:CGFloat = 40
    
    func updateDate() {
        propertiesModel.startDate = DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: max(dayFromDay1,0))
        propertiesModel.startWeek = DateServer.genrateDateStemp(offset: weekFromNow)
        propertiesModel.updateScores()
        if dayFromDay1 == -1 {
            UserDefaults.standard.set(false, forKey: "onDayView")
        } else {
            UserDefaults.standard.set(true, forKey: "onDayView")
        }
    }
    
    var body: some View {
        VStack(spacing:0){
            
            //MARK: Scores
            ScoreBar()
            
            //MARK: Week title bar
            WeekPicker(weekFromNow: $weekFromNow, dayFromDay1: $dayFromDay1, updateFunc: {
                updateDate()
            })
            .frame(height:hTitle).padding(.horizontal, mTitle).animation(.default)
            
            //MARK: Day picker
            DayPicker(weekFromNow:weekFromNow,dayFromDay1: $dayFromDay1, previewMode: previewMode, updateFunc: {
                updateDate()
            })
            .frame(height: hPicker).padding(.horizontal, mPicker)
            
            //MARK: Horizontal Divider, not shown in week calendar look
            if (!previewMode) || (dayFromDay1 != -1)
            {
                Divider().background(Color("background_grey"))
            }
            
            //MARK: Main content view
            if  dayFromDay1 == -1 {
                // Week view need to filter out the schedules with BEGIN time within the week range
                let predicate = NSPredicate(format: "(beginTime >= %@) AND (beginTime < %@)", propertiesModel.startDate as NSDate, DateServer.addOneWeek(date: propertiesModel.startDate) as NSDate)
                
                ScheduleListView(schedules: FetchRequest(entity: Schedule.entity(), sortDescriptors: [NSSortDescriptor(key: "beginTime", ascending: true)], predicate: predicate, animation: .default),previewMode:$previewMode)
            } else {
                let predicate = NSPredicate(format: "(endTime >= %@) AND (beginTime < %@)", propertiesModel.startDate as NSDate, DateServer.addOneDay(date: propertiesModel.startDate) as NSDate)
                // Calendar view need to filter out the scheduels with END time or BEGIN time within the day range
                withAnimation{
                    ScheduleDayView(schedules: FetchRequest(entity: Schedule.entity(), sortDescriptors: [NSSortDescriptor(key: "beginTime", ascending: true)], predicate: predicate, animation: .default))
                }
            } // end main content
            
            // Push things upward
            Spacer()
        } // end all VStack
        .onAppear(){
            if UserDefaults.standard.bool(forKey: "onDayView") {
                for r in 0...6 {
                    if DateServer.genrateDateStemp(offset: 0, daysOfWeek: r) == DateServer.startOfToday() {
                        dayFromDay1 = r
                    }
                }
            }
            updateDate()
        }
        .animation(.default)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
