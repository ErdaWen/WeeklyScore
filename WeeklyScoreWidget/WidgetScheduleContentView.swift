//
//  WidgetScheduleContentView.swift
//  WeeklyScoreWidgetExtension
//
//  Created by Erda Wen on 8/28/21.
//

import SwiftUI

struct WidgetScheduleContentView: View {
    var schedules:[ScheduleProperties]
    var body: some View {
        if schedules.count > 0{
            VStack(spacing:5){
                    ForEach(0..<min(schedules.count,4),id:\.self) { r in
                        WidgetScheduleTile(schedule: schedules[r])
                            .frame(height:28)
                    }
            }//endVStack
            .frame(height:139)
            .padding(.top,12)
            .padding(.bottom,18)
            .padding(.horizontal,10)
            

        } else {
            VStack{
                Text("No schedules")
                Text(Date(),style: .time)
            }
            
        }
        
    }
}
//
//struct WidgetScheduleContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        WidgetScheduleContentView()
//    }
//}
