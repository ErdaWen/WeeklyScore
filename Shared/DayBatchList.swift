//
//  DayBatchList.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/17/21.
//

import SwiftUI

struct DayBatchList: View {
    var schedules: FetchedResults<Schedule>
    let fsSub:CGFloat = 12
    
    var body: some View {
        if schedules.count == 0 {
            Text("No schedules to operate")
                .font(.system(size: fsSub))
                .fontWeight(.light)
                .foregroundColor(Color("text_black"))
                .frame(height:25)
        } else {
            ScrollView{
                VStack(spacing:8){
                    ForEach(schedules){schedule in
                        ScheduleTileSSView(schedule: schedule, showTitle: true)
                            .frame(height: 28)
                    }

                }
            }
        }
    }
}

//struct DayBatchList_Previews: PreviewProvider {
//    static var previews: some View {
//        DayBatchList()
//    }
//}
