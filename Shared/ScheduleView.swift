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
    @State var startDay = ""
    @State var dayNumbers:[Int] = [1, 2, 3, 4, 5, 6, 7]
    @State var weekdayNumbers:[String] = ["Mon", "Tue", "Wed", "Thr", "Fri", "Sat", "Sun"]
    
    // appearence related
    let fsScore:CGFloat = 18.0
    let fsTitle:CGFloat = 18.0
    let fsSub:CGFloat = 12.0
    let sButton:CGFloat = 22
    let mScores:CGFloat = 10
    let mScoreTitle:CGFloat = 5
    let mTitle:CGFloat = 20
    let hTitle:CGFloat = 38
    let rTitle:CGFloat = 12
    let mDateWeekday:CGFloat = 2
    let mPicker:CGFloat = 40
    let hPicker:CGFloat = 45
    let pPickerTextVer:CGFloat = 3
    let mButton:CGFloat = 10
    let minDragDist:CGFloat = 40

    
    func updateDate() {
        dayNumbers = DateServer.generateDays(offset:weekFromNow)
        weekdayNumbers = DateServer.generateWeekdays(offset:weekFromNow)
        startDay = DateServer.generateStartDay(offset:weekFromNow)
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
            HStack(spacing:mScores){
                if propertiesModel.deductScoreThisWeek != 0 {
                    Text("-\(propertiesModel.deductScoreThisWeek)").font(.system(size: fsScore)).foregroundColor(Color("text_red"))
                    Text(",").font(.system(size: fsTitle)).foregroundColor(Color("text_black")).fontWeight(.light)
                }
                Text("\(propertiesModel.gainedScoreThisWeek)").font(.system(size: fsScore)).foregroundColor(Color("text_green"))
                Image(systemName: "line.diagonal").foregroundColor(Color("text_black"))
                Text("\(propertiesModel.totalScoreThisWeek)").font(.system(size: fsScore)).foregroundColor(Color("text_black"))
            }
            .padding(.bottom, mScoreTitle)
            .onAppear(){
                propertiesModel.updateScores()
            }
            .animation(.default)
            
            //            //MARK: Score bar
            //            GeometryReader{ geo in
            //                ZStack(alignment: .leading){
            //                    RoundedRectangle(cornerRadius: 5)
            //                        .stroke(Color("text_black"),style:StrokeStyle(lineWidth: 1))
            //                    if propertiesModel.totalScoreThisWeek != 0 {
            //                        RoundedRectangle(cornerRadius: 5)
            //                            .frame(width: geo.frame(in: .global)
            //                                    .width / CGFloat(propertiesModel.totalScoreThisWeek) * CGFloat(propertiesModel.gainedScoreThisWeek + propertiesModel.deductScoreThisWeek)
            //                            )
            //                            .foregroundColor(Color("text_green").opacity(0.6))
            //                        RoundedRectangle(cornerRadius: 5)
            //                            .frame(width: geo.frame(in: .global)
            //                                    .width / CGFloat(propertiesModel.totalScoreThisWeek) * CGFloat(propertiesModel.deductScoreThisWeek)
            //                            )
            //                            .foregroundColor(Color("text_red"))
            //                    }
            //                }
            //            }
            //            .frame(height:8)
            //            .padding(.leading,110)
            //            .padding(.trailing,110)
            //            .padding(.bottom,1)
            
            //MARK: WeekTitle
            ZStack{
                // Background tile
                RoundedRectangle(cornerRadius: rTitle).foregroundColor(Color("background_grey"))
                
                HStack{
                    
                    //MARK: Week minus
                    Button {
                        weekFromNow -= 1
                        dayFromDay1 = -1
                        updateDate()
                    } label: {
                        Image(systemName: "arrowtriangle.backward.square").resizable().scaledToFit().foregroundColor(Color("text_black"))
                    }
                    .frame(width: sButton, height: sButton).padding(.leading,mButton)
                    
                    Spacer()
                    
                    //MARK: Week restore
                    Button {
                        weekFromNow = 0
                        dayFromDay1 = -1
                        updateDate()
                    } label: {
                        Text(weekFromNow == 0 ? "This week" : "Week of " + startDay ).foregroundColor(Color("text_black")).font(.system(size: fsTitle)).fontWeight(.light)
                    }
                
                    Spacer()

                    //MARK: Week plus
                    Button {
                        weekFromNow += 1
                        dayFromDay1 = -1
                        updateDate()
                    } label: {
                        Image(systemName: "arrowtriangle.right.square").resizable().scaledToFit().foregroundColor(Color("text_black"))
                    }
                    .frame(width: sButton, height: sButton).padding(.trailing,mButton)
                }
            }// end week title
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
                            Image(systemName: "list.dash").resizable().scaledToFit().padding(.top,8).frame(width: geo.frame(in: .global).width / 8 - 20, height:20 )
                            // hide text "list" when selected
                            if (dayFromDay1 != -1)
                            {
                                Text("List").font(.system(size: fsSub)).foregroundColor(Color("text_black")).fontWeight(.light).padding(.top, 4)
                            }
                        }
                        .frame(width: geo.frame(in: .global).width / 8 )
                        .onTapGesture {
                            dayFromDay1 = -1
                            updateDate()
                        }
                        
                        //MARK: Seven days
                        ForEach(0...6, id:\.self){ r in
                            
                            VStack(alignment: .center, spacing: mDateWeekday){
                                
                                Text("\(dayNumbers[r])")
                                    .font(.system(size: fsTitle)).fontWeight(DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: r) == DateServer.startOfToday() ? .semibold : .light)
                                    .foregroundColor(DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: r) == DateServer.startOfToday() ?  Color("text_red") : Color("text_black"))
                                    
                                Text("\(weekdayNumbers[r])")
                                    .font(.system(size: fsSub)).fontWeight(DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: r) == DateServer.startOfToday() ? .semibold : .light)
                                    .foregroundColor(DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: r) == DateServer.startOfToday() ?  Color("text_red") : Color("text_black"))
                            }
                            .animation(.none)
                            .frame(width: geo.frame(in: .global).width / 8 )
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
            
            Divider().background(Color("background_grey"))
            
            //MARK: Main content view
            if  dayFromDay1 == -1 {
                // Week view need to filter out the schedules with BEGIN time within the week range
                ScheduleListView(schedules: FetchRequest(entity: Schedule.entity(), sortDescriptors: [NSSortDescriptor(key: "beginTime", ascending: true)]
                                                         , predicate: NSPredicate(format: "(beginTime >= %@) AND (beginTime < %@)", propertiesModel.startDate as NSDate, DateServer.addOneWeek(date: propertiesModel.startDate) as NSDate), animation: .default))
//                    .gesture(DragGesture(minimumDistance: minDragDist)
//                                .onEnded({ value in
//                                    if value.translation.width < 0{
//                                        dayFromDay1 += 1
//                                        updateDate()
//                                    }
//                                }))

            } else {
                // Calendar view need to filter out the scheduels with END time or BEGIN time within the day range
                withAnimation{
                    ScheduleDayView(schedules: FetchRequest(entity: Schedule.entity(), sortDescriptors: [NSSortDescriptor(key: "beginTime", ascending: true)]
                                                            , predicate: NSPredicate(format: "(endTime >= %@) AND (beginTime < %@)", propertiesModel.startDate as NSDate, DateServer.addOneDay(date: propertiesModel.startDate) as NSDate), animation: .default))
    //                    .gesture(DragGesture(minimumDistance: minDragDist)
    //                                .onEnded({ value in
    //                                    if value.translation.width < 0{
    //                                        dayFromDay1 = min(dayFromDay1 + 1, 6)
    //                                        updateDate()
    //                                    }
    //                                    if value.translation.width > 0{
    //                                        dayFromDay1 -= 1
    //                                        updateDate()
    //                                    }
    //                                }))
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
