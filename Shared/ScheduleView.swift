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
    @State var addViewPresented = false
    
    var body: some View {
        VStack(){
            List(entryModel.entries){ r in
                VStack{
                    Text(r.habitTitle)
                    Text(entryModel.printTime(inputTime: r.beginTime))
                    Text(entryModel.printTime(inputTime: r.endTime))
                }
            }
            Button("Add Schedule") {addViewPresented.toggle()}.sheet(isPresented: $addViewPresented, content: {
                AddHabitView(addHabitViewPresented: $addViewPresented)
            })
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
