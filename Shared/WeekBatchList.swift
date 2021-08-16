//
//  WeekBatchLisst.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/14/21.
//

import SwiftUI

struct WeekBatchList: View {
    var schedules: FetchedResults<Schedule>
    
    let fsSub:CGFloat = 12
    
    var body: some View {
        if schedules.count == 0 {
            Text("No schedules")
        } else {
            let startOfWeek = DateServer.startOfThisWeek(date: schedules[0].beginTime)
            let weekdayNumbers = DateServer.generateWeekdays(offset:0)
            VStack(spacing:3){
                ForEach(0...6, id:\.self){ offDay in
                    let dayLookingAt = DateServer.genrateDateStemp(startOfWeek: startOfWeek, daysOfWeek: offDay)
                    let schedulesFiltered = schedules.filter { schedule in
                        return (schedule.beginTime >= dayLookingAt) && (schedule.beginTime < DateServer.addOneDay(date: dayLookingAt))
                    }
                    // MARK: Each day bar
                    HStack{
                        Text(weekdayNumbers[offDay])
                            .font(.system(size: fsSub))
                            .fontWeight(.light)
                            .foregroundColor(Color("text_black"))
                            .frame(width: 30)
                            .multilineTextAlignment(.trailing)
                        
                        ScrollView(.horizontal){
                            if schedulesFiltered.count == 0{
                                Text("No Schedules")
                                    .font(.system(size: fsSub))
                                    .fontWeight(.light)
                                    .foregroundColor(Color("text_black"))
                                    .frame(height:25)
                            } else {
                                HStack{
                                    ForEach(schedulesFiltered) { scheduleEach in
                                        
                                        ScheduleTileSSView(schedule: scheduleEach)
                                            .frame(width: 30, height: 25)
                                        
                                    }
                                }
                            }//end if no schedule
                        }// end scroll
                        
                        
                    }// end each day bar
                    
                }//end ForEach
            }//end Vstack
            
        }
        
    }
}

//struct WeekBatchLisst_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekBatchList()
//    }
//}
