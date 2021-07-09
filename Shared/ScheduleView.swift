//
//  ScheduleView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI
import UIKit

struct ScheduleView: View {
    
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    @State var addViewPresented = false
    @State var completionViewPresented = false
    
    var body: some View {
        VStack(){
            
            ForEach(0...entryModel.entries.count-1, id:\.self){ r in
                HStack(){
                    VStack{
                        if let posInd = habitModel.idIndexing[entryModel.entries[r].habitid]{
                            Text(habitModel.habits[posInd].title)
                        }
                        Text(entryModel.printTime(inputTime: entryModel.entries[r].beginTime))
                        Text(entryModel.printTime(inputTime: entryModel.entries[r].endTime))
                        Text("\(entryModel.entries[r].scoreGained)/\(entryModel.entries[r].score)")
                    }
                    
                    Button("Complete") {
//                        entryModel.entries[r].complete()
//                        print("setting complete")
//                        entryModel.refresh.toggle()
                        completionViewPresented.toggle()
                    }.sheet(isPresented: $completionViewPresented, content: {
                        ChangeCompletionView(changeCompletionViewPresented: $completionViewPresented,entryIndex:r)
                    })
                }
            }
            Button("Add Schedule") {addViewPresented.toggle()}.sheet(isPresented: $addViewPresented, content: {
                AddEntryView(addEntryViewPresented: $addViewPresented)
            })
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView().environmentObject(HabitModel()).environmentObject(EntryModel())
    }
}
