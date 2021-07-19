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
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [],animation: .default)
    private var schedules: FetchedResults<Schedule>
    
    @State var addViewPresented = false
    @State var completionViewPresented = false
    @State var changeViewPresented = false
    
    var body: some View {
        VStack{
            if entryModel.entries.count > 0 {
                TabView{
                    // , id:\.self
                    ForEach(0..<entryModel.entries.count,id: \.self){ r in
                        HStack(){
                            VStack{
                                if let posInd = habitModel.idIndexing[entryModel.entries[r].habitid]{
                                    Button(habitModel.habits[posInd].title){
                                        changeViewPresented.toggle()
                                    }.sheet(isPresented: $changeViewPresented, content: {
                                        ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, entryIndex: r)
                                    })
                                }
                                Text(entryModel.printTime(inputTime: entryModel.entries[r].beginTime))
                                Text(entryModel.printTime(inputTime: entryModel.entries[r].endTime))
                                Text("\(entryModel.entries[r].scoreGained)/\(entryModel.entries[r].score)")
                            }
                            
                            Button("Record\(r)") {
                                completionViewPresented.toggle()
                            }.sheet(isPresented: $completionViewPresented, content: {
                                ChangeCompletionView(changeCompletionViewPresented: $completionViewPresented,entryIndex:r)
                            })
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            } else {
                Text("No Schedule")
            }
            
            Button("Add Schedule") {addViewPresented.toggle()}.sheet(isPresented: $addViewPresented, content: {
                AddScheduleView(addEntryViewPresented: $addViewPresented)
            })
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView().environmentObject(HabitModel()).environmentObject(EntryModel())
    }
}
