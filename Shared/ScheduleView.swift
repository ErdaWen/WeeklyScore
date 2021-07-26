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
    
    @EnvironmentObject var propertiesModel:PropertiesModel

    
    var body: some View {
        VStack{
            HStack(spacing:20){
                Text("Statistic")
                Text("\(propertiesModel.gainedScoreThisWeek)/\(propertiesModel.totalScoreThisWeek)")
            }.onAppear(){
                propertiesModel.updateScores()
            }
            if schedules.count > 0 {
                TabView{
                    // , id:\.self
                    ForEach(0..<schedules.count,id: \.self){ r in
                        HStack(){
                            VStack{
                                // MARK: Title, as well as the change schedule button
                                Button(schedules[r].items.titleIcon + schedules[r].items.title){
                                        changeViewPresented.toggle()
                                    }.sheet(isPresented: $changeViewPresented, content: {
                                        ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, schedule: schedules[r])
                                    })
                                
                                Text(DateServer.printTime(inputTime: schedules[r].beginTime))
                                Text(DateServer.printTime(inputTime: schedules[r].endTime))
                                Text("\(schedules[r].scoreGained)/\(schedules[r].score)")
                            }
                            // MARK: Record button
                            Button("Record\(r)") {
                                completionViewPresented.toggle()
                            }.sheet(isPresented: $completionViewPresented, content: {
                                ChangeCompletionView(changeCompletionViewPresented: $completionViewPresented,schedule: schedules[r])
                            })
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            } else {
                Text("No Schedules")
            }
            
            Button("Add Schedule") {addViewPresented.toggle()}.sheet(isPresented: $addViewPresented, content: {
                AddScheduleView(addScheduleViewPresented: $addViewPresented)
            })
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
