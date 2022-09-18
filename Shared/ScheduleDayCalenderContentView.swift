//
//  ScheduleDayContentView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/7/21.
//

import SwiftUI

struct ScheduleDayCalenderContentView: View {
    
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var schedules: FetchedResults<Schedule>
    var interCord:Double
    var today:Date
    
    var body: some View {
        ForEach(schedules){ schedule in
            // Calcualte cordinate
            let (startCord,heightCord) = CordServer.calculateCord(startTime: schedule.beginTime, endTime: schedule.endTime, today: today, unit: interCord, durationBased: schedule.items.durationBased)
            
            VStack(spacing:0){
                Spacer()
                    .frame(height:CGFloat(startCord))
                ScheduleTileView(schedule: schedule, showTime:false, showTitle:true)
                    .frame(height:CGFloat(heightCord))
                    .padding(.leading, 50)
                Spacer()
            }
        }
    }
}

//struct ScheduleDayContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDayCalenderViewContentView()
//    }
//}
