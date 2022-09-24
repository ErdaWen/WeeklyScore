//
//  ScheduleView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI
import UIKit
import WidgetKit


struct ScheduleView: View {
    
    // Environment
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    // week offset
    @State var weekFromNow = 0
    // day offset
    @State var dayFromDay1:Int
    
    // String arrays for title and day picker dispaly
    @State var previewMode = UserDefaults.standard.bool(forKey: "previewMode")
    @State var addViewPresented = false
    @State var batchAddViewPresented = false

    //Use factor for list style view
    @State var factor = UserDefaults.standard.double(forKey: "listScaleFactor")
    //Use interCord for calender style view
    @State var interCord = 50.0
    
    // appearence related
    let mTitle:CGFloat = 20
    let hTitle:CGFloat = 38
    let mPicker:CGFloat = 40
    let hPicker:CGFloat = 45
    let minDragDist:CGFloat = 40
    let mButtons: CGFloat = 20
    let sButton: CGFloat = 18
    let mButtonUp:CGFloat = 0
    
    init(){
        self.dayFromDay1 = -1
        if UserDefaults.standard.bool(forKey: "onDayView") {
            for r in 0...6 {
                if DateServer.genrateDateStemp(offset: 0, daysOfWeek: r) == DateServer.startOfToday() {
                    self._dayFromDay1 = State(initialValue: r)
                }
            }
        }
    }
    
    func updateDate() {
        propertiesModel.startDate = DateServer.genrateDateStemp(offset: weekFromNow,
                                                                daysOfWeek: max(dayFromDay1,0))
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
            ScoreBar()
            WeekPicker(weekFromNow: $weekFromNow, dayFromDay1: $dayFromDay1)
            .frame(height:hTitle)
            .padding(.horizontal, mTitle)
            .animation(.default)
            
            ZStack(alignment:.top){
                DayPicker(weekFromNow:weekFromNow,dayFromDay1: $dayFromDay1, previewMode: previewMode)
                .padding(.horizontal, mPicker)
                conditionalDividor
            }.frame(height: hPicker)
            
            ZStack{
                mainContentTabs
                // MARK: Preview button and slider
                VStack{
                    scheduleOperationButtons
                    Spacer()
                    previewButtonSlider
                }
            }
        } // end all VStack
        .onAppear(){
            WidgetCenter.shared.reloadAllTimelines()
            updateDate()
        }
        .onChange(of: dayFromDay1, perform: { _ in
            updateDate()
        })
        .onChange(of: weekFromNow, perform: { _ in
            updateDate()
        })
        .animation(.default)
    }
    
    var conditionalDividor: some View {
        //Horizontal Divider, not shown in week calendar look
        VStack{
            // Push the divider to bottom
            Spacer()
            if (!previewMode) || (dayFromDay1 != -1)
            {
                Divider().background(Color("background_grey"))
            }
        }
    }
    
    var mainContentTabs: some View{
        TabView(selection: $dayFromDay1) {
            ForEach(-1...6,id:\.self){ daystart in
                //MARK: Main content view
                if  daystart == -1 {
                    // Week view need to filter out the schedules with BEGIN time within the week range
                    let predicate = NSPredicate(format: "(beginTime >= %@) AND (beginTime < %@)", propertiesModel.startDate as NSDate, DateServer.addOneWeek(date: propertiesModel.startDate) as NSDate)
                    let sortDescriptors = [NSSortDescriptor(key: "beginTime", ascending: true),
                                           NSSortDescriptor(key: "endTime", ascending: true)]
                    
                    ScheduleWeekView(schedules: FetchRequest(entity: Schedule.entity(), sortDescriptors: sortDescriptors, predicate: predicate, animation: .default),
                                     previewMode:$previewMode,
                                     factor: factor, interCord: interCord).tag(daystart)
                } else {
                    let theday = DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: daystart)
                    
                    let predicate = NSPredicate(format: "(endTime >= %@) AND (beginTime < %@)", theday as NSDate, DateServer.addOneDay(date: theday) as NSDate)
                    // Calendar view need to filter out the scheduels with END time or BEGIN time within the day range
                    
                    let sortDescriptors = [NSSortDescriptor(key: "beginTime", ascending: true),
                                           NSSortDescriptor(key: "endTime", ascending: true)]
                    
                    ScheduleDayView(schedules: FetchRequest(entity: Schedule.entity(), sortDescriptors: sortDescriptors, predicate: predicate, animation: .default),
                                    today:theday,
                                    factor: factor,interCord: interCord,previewMode: self.previewMode).tag(daystart)
                    
                } // end main content
            }
        }.tabViewStyle(.page)
    }
    
    var scheduleOperationButtons: some View{
        HStack(spacing:mButtons) {
            Spacer()
            FloatButton(systemName: "plus.square", sButton: sButton) {
                addViewPresented = true
            }
            .sheet(isPresented: $addViewPresented, content: {
                AddScheduleView(initDate: (dayFromDay1 == -1 ? Date() :propertiesModel.startDate), addScheduleViewPresented: $addViewPresented)
                    .environment(\.managedObjectContext,self.viewContext)
            })
            
            
            FloatButton(systemName: "plus.square.on.square", sButton: sButton) {
                batchAddViewPresented = true
            }
            .sheet(isPresented: $batchAddViewPresented) {
                if dayFromDay1 == -1 {
                    let predicate = NSPredicate(format: "(beginTime >= %@) AND (beginTime < %@)", propertiesModel.startDate as NSDate, DateServer.addOneWeek(date: propertiesModel.startDate) as NSDate)
                    let sortDescriptors = [NSSortDescriptor(key: "beginTime", ascending: true),
                                           NSSortDescriptor(key: "endTime", ascending: true)]
                    
                    WeekBatchOpearationView(dayStart: propertiesModel.startDate,
                                            schedules: FetchRequest(entity: Schedule.entity(), sortDescriptors: sortDescriptors, predicate: predicate, animation: .default),
                                            singleDay: false, addBatchScheduleViewPresented: $batchAddViewPresented)
                    .environment(\.managedObjectContext,self.viewContext)
                }
                else{
                    let theday = DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: dayFromDay1)
                    
                    let predicate = NSPredicate(format: "(endTime >= %@) AND (beginTime < %@)", theday as NSDate, DateServer.addOneDay(date: theday) as NSDate)
                    // Calendar view need to filter out the scheduels with END time or BEGIN time within the day range
                    
                    let sortDescriptors = [NSSortDescriptor(key: "beginTime", ascending: true),
                                           NSSortDescriptor(key: "endTime", ascending: true)]
                    
                    DayBatchOperationView(dayStart: propertiesModel.startDate,
                                          schedules: FetchRequest(entity: Schedule.entity(), sortDescriptors: sortDescriptors, predicate: predicate, animation: .default)
                                          , singleDay: true, addBatchScheduleViewPresented: $batchAddViewPresented)
                    .environment(\.managedObjectContext,self.viewContext)
                }
                
            }
            
            Spacer()
        } //end top Buttons HStack
        .padding(.top,mButtonUp)
    }
    
    var previewButtonSlider: some View{
        ZStack{
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0.6),Color("background_white").opacity(0)]), startPoint: .bottom, endPoint: .top))
            
            HStack (spacing:mButtons) {
                
                Button {
                    previewMode = !previewMode
                } label: {
                    Image(systemName:  previewMode ? "list.bullet.rectangle" : "list.bullet.rectangle.fill")
                        .resizable().scaledToFit()
                        .foregroundColor(Color("text_black"))
                        .frame(height:sButton)
                        .padding(.leading,70)
                        .padding(.top,19)
                }
                
                
                if previewMode {
                    CustomSlider(interCord: $interCord, minValue: 35, maxValue: 90)
                        .frame(height:38)
                    //.padding(.leading,80)
                        .padding(.trailing,60)
                } else {
                    CustomSlider_list(factor: $factor, minValue: 0, maxValue: 30)
                        .frame(height:38)
                    //.padding(.leading,80)
                        .padding(.trailing,60)
                }
            } // HStack
        }.frame(height:75)
    }
}

//struct ScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleView()
//    }
//}
