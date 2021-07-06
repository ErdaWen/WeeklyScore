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
                HStack(){
                    VStack{
                        Text(r.habitTitle)
                        Text(entryModel.printTime(inputTime: r.beginTime))
                        Text(entryModel.printTime(inputTime: r.endTime))
                        Text(String(r.scoreGained))
                    }
                    
                    Button("Complete") {
                        r.complete()
                        print("setting complete")
                    }
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
        ScheduleView().environmentObject(HabitModel()).environmentObject(EntryModel())
    }
}
