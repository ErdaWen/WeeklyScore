//
//  WidgetScheduleContentView.swift
//  WeeklyScoreWidgetExtension
//
//  Created by Erda Wen on 8/28/21.
//

import SwiftUI

struct WidgetScheduleContentView: View {
    var schedules:[ScheduleProperties]
    var compact:Bool
    var body: some View {
        if schedules.count > 0{
            VStack(spacing: compact ? 5 : 8){
                ForEach(0..<min(schedules.count,(compact ? 4: 3)),id:\.self) { r in
                        WidgetScheduleTile(schedule: schedules[r],compact: compact)
                            .frame(height:compact ? 28 : 35)
                    }
                if schedules.count==1{
                    Spacer().frame(maxHeight: 70)
                }
                if schedules.count==2{
                    Spacer().frame(maxHeight: 40)
                }
            }//endVStack
            .frame(height:139)
            .padding(.top,12)
            .padding(.bottom,18)
            .padding(.horizontal,10)
            

        } else {
            VStack{
                Text("🌵 No schedules")
                    .foregroundColor(Color("text_black"))
                    .font(.system(size: 16))
                    .fontWeight(.light)
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
