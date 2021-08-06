//
//  ScheduleListContent.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/5/21.
//

import SwiftUI

struct ScheduleListContentView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var schedules: FetchedResults<Schedule>
    var factor:Double
    
    let mHorizon:CGFloat = 20
    let mButtonUp:CGFloat = 10
    let sButton:CGFloat = 22
    let mButtons:CGFloat = 16
    let mTitleButton:CGFloat = 3
    let topSpacing:CGFloat = 40

    var body: some View {
        ScrollView{
            Spacer()
                .frame(height:topSpacing)
            if schedules.count != 0{
                VStack{
                    ForEach(0...6,id: \.self){ offDay in
                        let dayLookingAt = DateServer.genrateDateStemp(startOfWeek: propertiesModel.startWeek, daysOfWeek: offDay)
                        let schedulesFiltered = schedules.filter { schedule in
                            return (schedule.beginTime >= dayLookingAt) && (schedule.beginTime < DateServer.addOneDay(date: dayLookingAt))
                        }
                        if (schedulesFiltered.count > 0) || (dayLookingAt == DateServer.startOfToday()){
                            // Day Divider
                            if dayLookingAt == DateServer.startOfToday() {
                                if schedulesFiltered.count == 0 {
                                    Text("No schedules for today")
                                        .foregroundColor(Color("text_red"))
                                        .fontWeight(.bold)
                                        .font(.system(size: 12))
                                        .padding(.top,5)
                                } else {
                                    Text("Today")
                                        .foregroundColor(Color("text_red"))
                                        .font(.system(size: 12))
                                        .fontWeight(.bold)
                                        .padding(.top,5)
                                }
                            } else if dayLookingAt == DateServer.minusOneDay(date: DateServer.startOfToday()) {
                                Text("Yesterday")
                                    .foregroundColor(Color("text_black").opacity(0.5))
                                    .font(.system(size: 12))
                                    .padding(.top,5)
                            } else if dayLookingAt == DateServer.addOneDay(date: DateServer.startOfToday()) {
                                Text("Tomorrow")
                                    .foregroundColor(Color("text_black").opacity(0.5))
                                    .font(.system(size: 12))
                                    .padding(.top,5)

                            } else {
                                Text(DateServer.printWeekday(inputTime: dayLookingAt))
                                    .foregroundColor(Color("text_black").opacity(0.5))
                                    .font(.system(size: 12))
                                    .padding(.top,5)
                            }
                            
                            ForEach(schedulesFiltered){ schedule in
                                if (schedule.beginTime >= dayLookingAt) && (schedule.beginTime < DateServer.addOneDay(date: dayLookingAt) ){
                                    ScheduleTileView(schedule: schedule, showTime:true)
                                        .frame(height: CordServer.calculateHeight(startTime: schedule.beginTime, endTime: schedule.endTime, factor: factor,minHeight:25,maxHeight:100) + 20)
                                }
                            }
                        }

                    }// end divider ForEach
                }
                .padding(.horizontal, mHorizon)
            } //end if there is schedule
        } //end ScoreView
        .animation(.default)
    }
}

//struct ScheduleListContent_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListContent()
//    }
//}
