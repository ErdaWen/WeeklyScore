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
            VStack{
                
                    ForEach(0..<schedules.count,id:\.self) { r in
                        HStack{
                            Text(schedules[r].beginTimeString)
                            Text(schedules[r].title)
                        }
                        
                    }
            }//endVStack
        } else {
            Text("No schedules")
        }
        
    }
}
//
//struct WidgetScheduleContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        WidgetScheduleContentView()
//    }
//}
