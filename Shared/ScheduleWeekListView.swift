//
//  ScheduleListContent.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/5/21.
//

import SwiftUI

struct ScheduleWeekListView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var schedules: FetchedResults<Schedule>
    var factor:Double
    
    let mHorizon:CGFloat = 20
    let mButtonUp:CGFloat = 10
    let sButton:CGFloat = 22
    let mButtons:CGFloat = 16
    let mTitleButton:CGFloat = 3
    let topSpacing:CGFloat = 150
    let bottomSpacing:CGFloat = 50


    var body: some View {
        ScrollView{
            Spacer()
                .frame(height:topSpacing)
            if schedules.count != 0{
                VStack{
                    ForEach(0...6,id: \.self){ offDay in
                        //MARK: Filter data
                        let dayLookingAt = DateServer.genrateDateStemp(startOfWeek: propertiesModel.startWeek, daysOfWeek: offDay)
                        let schedulesFiltered = schedules.filter { schedule in
                            return (schedule.beginTime >= dayLookingAt) && (schedule.beginTime < DateServer.addOneDay(date: dayLookingAt))
                        }
                        // Genrate title
                        let (dayDescription, isToday) = DateServer.describeDay(date: dayLookingAt)
                        if isToday {
                            Text((schedulesFiltered.count > 0) ? "Today" : "No schedules today")
                                .foregroundColor(Color("text_red")).font(.system(size: 12)).fontWeight(.bold)
                                .padding(.top,5)
                        } else if (schedulesFiltered.count > 0) {
                            Text(dayDescription)
                                .foregroundColor(Color("text_black").opacity(0.5))
                                .font(.system(size: 12))
                                .padding(.top,5)
                        }
                        //MARK: Generate tiles
                        ForEach(schedulesFiltered){ schedule in
                                ScheduleTileView(schedule: schedule, showTime:true, showTitle:true)
                                    .frame(height: CordServer.calculateHeight(startTime: schedule.beginTime, endTime: schedule.endTime, factor: factor,minHeight:25,maxHeight:100) + 20)
                        }

                    }// end divider ForEach
                }
                .padding(.horizontal, mHorizon)
            } //end if there is schedule
            Spacer()
                .frame(height:bottomSpacing)
        } //end ScoreView
        .animation(.default)
    }
}

//struct ScheduleListContent_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListContent()
//    }
//}
