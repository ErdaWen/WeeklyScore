//
//  ScheduleView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI

struct ScheduleView: View {
    
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    
    var body: some View {
        List(entryModel.entries){ r in
            VStack{
                Text(r.habitTitle)
                Text(entryModel.printTime(inputTime: r.beginTime))
                Text(entryModel.printTime(inputTime: r.endTime))
            }
        }
        .padding(.leading, 14.0)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
