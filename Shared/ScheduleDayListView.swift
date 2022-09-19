//
//  ScheduleDayListView.swift
//  WeeklyScore (iOS)
//
//  Created by Erda Wen on 9/19/22.
//

import SwiftUI

struct ScheduleDayListView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var schedules: FetchedResults<Schedule>
    var factor:Double
    
    let mTitleButton:CGFloat = 3
    let topSpacing:CGFloat = 40
    let bottomSpacing:CGFloat = 50
    let mHorizon:CGFloat = 20
    
    var body: some View {
        ScrollView{
            Spacer()
                .frame(height:topSpacing)
            if schedules.count != 0{
                VStack{
                    ForEach(schedules){ schedule in
                            ScheduleTileView(schedule: schedule, showTime:true, showTitle:true)
                                .frame(height: CordServer.calculateHeight(startTime: schedule.beginTime, endTime: schedule.endTime, factor: factor,minHeight:25,maxHeight:100) + 20)
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

//struct ScheduleDayListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDayListView()
//    }
//}
