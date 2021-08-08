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
    let fsTitle:CGFloat = 18.0
    let fsSub:CGFloat = 12.0
    let mTitle:CGFloat = 20
    let hTitle:CGFloat = 38
    let mDateWeekday:CGFloat = 2
    let mPicker:CGFloat = 40
    let hPicker:CGFloat = 45
    let pPickerTextVer:CGFloat = 3
    let minDragDist:CGFloat = 40
    let wDividerCompensate:CGFloat = 0
    
    
    func updateDate() {
        dayNumbers = DateServer.generateDays(offset:weekFromNow)
        weekdayNumbers = DateServer.generateWeekdays(offset:weekFromNow)
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
            ScoreBarView()
            
            //MARK: Week title bar
            WeekPicker(weekFromNow: $weekFromNow, dayFromDay1: $dayFromDay1, updateFunc: {
                updateDate()
            })
            .frame(height:hTitle).padding(.horizontal, mTitle).animation(.default)
            
            //MARK: Day picker
            
            ZStack(alignment:.leading){
                GeometryReader { geo in
                    //MARK: Selection tile
                    Rectangle().foregroundColor(Color("background_grey"))
                        .frame(width:geo.frame(in: .global).width / 8)
                        .padding(.leading, geo.frame(in: .global).width / 8 * CGFloat(dayFromDay1 + 1))
                        .animation(.default)
                    
                    HStack(spacing:0){
                        //MARK: List icon
                        VStack(alignment: .center, spacing: 2){
                            Image(systemName: previewMode ? "calendar" : "list.dash").resizable().scaledToFit().padding(.top,8).frame(width: geo.frame(in: .global).width / 8 - 20, height: previewMode ? 24 : 20)
                                .padding(.bottom, previewMode ? -2 : 0)
                            // hide text "list" when selected
                            if (dayFromDay1 != -1)
                            {
                                Text("All").font(.system(size: fsSub)).foregroundColor(Color("text_black")).fontWeight(.light).padding(.top, 4)
                            }
                        }
                        .frame(width: geo.frame(in: .global).width / 8 )
                        .onTapGesture {
                            dayFromDay1 = -1
                            updateDate()
                        }
                        
                        //MARK: Seven days
                        ForEach(0...6, id:\.self){ r in
                            let isToday = DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: r) == DateServer.startOfToday()
                            ZStack(){
                                VStack(alignment: .center, spacing: mDateWeekday){
                                    
                                    Text("\(dayNumbers[r])")
                                        .font(.system(size: fsTitle)).fontWeight(isToday ? .semibold : .light)
                                        .foregroundColor(isToday ?  Color("text_red") : Color("text_black"))
                                    
                                    Text("\(weekdayNumbers[r])")
                                        .font(.system(size: fsSub)).fontWeight(isToday ? .semibold : .light)
                                        .foregroundColor(isToday ?  Color("text_red") : Color("text_black"))
                                }
                                .animation(.none)
                                
                                // For preview mode, add verticle line to form a calendar look
                                if previewMode && (dayFromDay1 == -1 ){
                                    HStack{
                                        Spacer()
                                        Divider()
                                    }
                                }
                            }
                            .frame(width: geo.frame(in: .global).width / 8 + wDividerCompensate)
                            .padding(.top, pPickerTextVer)
                            .onTapGesture {
                                dayFromDay1 = r
                                updateDate()
                            }
                        }// end seven days
                    } // end 8 icons
                    
                } //end GeoReader
            } // end day picker
            .frame(height: hPicker).padding(.horizontal, mPicker)
            
            //MARK: Horizontal Divider, not shown in week calendar look
            if (!previewMode) || (dayFromDay1 != -1)
            {
                Divider().background(Color("background_grey"))
            }
            
            //MARK: Main content view
            if  dayFromDay1 == -1 {
                // Week view need to filter out the schedules with BEGIN time within the week range
                ScheduleListView(schedules: FetchRequest(entity: Schedule.entity(), sortDescriptors: [NSSortDescriptor(key: "beginTime", ascending: true)]
                                                         , predicate: NSPredicate(format: "(beginTime >= %@) AND (beginTime < %@)", propertiesModel.startDate as NSDate, DateServer.addOneWeek(date: propertiesModel.startDate) as NSDate), animation: .default),previewMode:$previewMode)

                
            } else {
                // Calendar view need to filter out the scheduels with END time or BEGIN time within the day range
                withAnimation{
                    ScheduleDayView(schedules: FetchRequest(entity: Schedule.entity(), sortDescriptors: [NSSortDescriptor(key: "beginTime", ascending: true)]
                                                            , predicate: NSPredicate(format: "(endTime >= %@) AND (beginTime < %@)", propertiesModel.startDate as NSDate, DateServer.addOneDay(date: propertiesModel.startDate) as NSDate), animation: .default))
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
