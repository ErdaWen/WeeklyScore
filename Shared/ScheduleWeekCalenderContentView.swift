//
//  ScheduleListPreviewContentView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/6/21.
//

import SwiftUI

struct ScheduleWeekCalenderContentView: View {
    
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var schedules: FetchedResults<Schedule>
    var interCord:Double
    var timeNow:Date
    
    let wThreshhold:CGFloat = 100
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing:0){
                ForEach(-1...6,id: \.self){ offDay in
                    if offDay != -1{
                        let dayLookingAt = DateServer.genrateDateStemp(startOfWeek: propertiesModel.startWeek, daysOfWeek: offDay)
                        let schedulesFiltered = schedules.filter { schedule in
                            return (schedule.beginTime >= dayLookingAt) && (schedule.endTime < DateServer.addOneDay(date: dayLookingAt))
                        }
                        //MARK: VStack that contains one days view
                        ZStack(alignment: .top){
                            ForEach(schedulesFiltered){ schedule in
                                // Calcualte cordinate
                                let (startCord,heightCord) = CordServer.calculateCord(startTime: schedule.beginTime, endTime: schedule.endTime, today: dayLookingAt, unit: interCord, durationBased: schedule.items.durationBased)
                                
                                VStack(spacing:0){
                                    Spacer()
                                        .frame(height:CGFloat(startCord))
                                    if geo.frame(in: .global).width / 8 < wThreshhold {
                                        ScheduleTileCompactView(schedule: schedule)
                                            .frame(height:CGFloat(heightCord))
                                    } else {
                                        ScheduleTileView(schedule: schedule, showTime:false,showTitle:false)
                                            .frame(height:CGFloat(heightCord))
                                    }
                                    
                                    Spacer()
                                }
                            }// end foreach
                            
                            //MARK:Today circle
                            if dayLookingAt == DateServer.startOfToday(){
                                let startMin = DateServer.getMinutes(date: timeNow)
                                let startCord = interCord * Double(startMin) / 60.0
                                VStack(spacing:0){
                                    Spacer()
                                        .frame(height:CGFloat(startCord)+1)
                                    Circle().frame(height:8).foregroundColor(Color("text_red")).padding(.trailing, geo.frame(in: .global).width / 8 - 10)
                                    Spacer()
                                }
                                
                            }
                        }
                        .padding(.trailing, 2)
                        .frame(width: geo.frame(in: .global).width / 8  )
                    } else {
                        //MARK: day == -1 empty VStack
                        VStack{}.frame(width: geo.frame(in: .global).width / 8 )
                    }// end if offDay != -1
                } // end foreach -1...6
            }// end Hstack
        }// end GeoReader
    }
}

//struct ScheduleListPreviewContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListPreviewContentView()
//    }
//}
