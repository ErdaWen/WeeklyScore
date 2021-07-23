//
//  ScheduleView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI
import UIKit

struct ScheduleView: View {
    
    @State var addViewPresented = false
    @State var completionViewPresented = false
    @State var changeViewPresented = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var schedules: FetchedResults<Schedule>
    
    var body: some View {
        VStack{
            if schedules.count > 0 {
                TabView{
                    // , id:\.self
                    ForEach(0..<schedules.count,id: \.self){ r in
                        HStack(){
                            VStack{
                                Button(schedules[r].items.title){
                                        changeViewPresented.toggle()
                                    }.sheet(isPresented: $changeViewPresented, content: {
                                        ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, entryIndex: r)
                                    })
                                
                                Text(DateServer.printTime(inputTime: schedules[r].beginTime))
                                Text(DateServer.printTime(inputTime: schedules[r].endTime))
                                Text("\(schedules[r].scoreGained)/\(schedules[r].score)")
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

//struct ScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleView().environmentObject(HabitModel()).environmentObject(EntryModel())
//    }
//}
