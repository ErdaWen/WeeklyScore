//
//  ScheduleListView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/26/21.
//

import SwiftUI

struct ScheduleListView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel

    @Environment(\.managedObjectContext) private var viewContext
    
    @State var schedules = [Schedule]()
    @State var zoomin = true
    
    func initiateView() {
        schedules = []
        print(schedules)
        let endDate = DateServer.addOneWeek(date: propertiesModel.startDate)
        let fetchRequest = Schedule.schedulefetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(beginTime >= %@) AND (beginTime < %@)", propertiesModel.startDate as NSDate, endDate as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "beginTime", ascending: true)]
        do {
            schedules = try viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        print("Fetched starts " + DateServer.printTime(inputTime: propertiesModel.startDate))
        print("Fetched ends " + DateServer.printTime(inputTime: endDate))
        print(schedules)

    }
    
    var body: some View {
        VStack{
            Text(DateServer.printTime(inputTime: propertiesModel.startDate))
            if schedules.count != 0{
                VStack{
                    // , id:\.self
                    ForEach(0..<schedules.count,id: \.self){ r in
                        
                        ScheduleTileView(schedule: schedules[r])
                            .frame(height: zoomin ? 45 : 25)
                            
//                        VStack(){
//                            VStack{
//                                // MARK: Title, as well as the change schedule button
//                                Button(schedules[r].items.titleIcon + schedules[r].items.title){
//                                        changeViewPresented.toggle()
//                                    }.sheet(isPresented: $changeViewPresented, content: {
//                                        ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, schedule: schedules[r])
//                                    })
//
//                                Text(DateServer.printTime(inputTime: schedules[r].beginTime))
//                                Text(DateServer.printTime(inputTime: schedules[r].endTime))
//                                Text("\(schedules[r].scoreGained)/\(schedules[r].score)")
//                            }
//                            // MARK: Record button
//                            Button("Record\(r)") {
//                                completionViewPresented.toggle()
//                            }.sheet(isPresented: $completionViewPresented, content: {
//                                ChangeCompletionView(changeCompletionViewPresented: $completionViewPresented,schedule: schedules[r])
//                            })
//                        }
                    }
                }
                .padding(.horizontal,20)
            }
        }
        .onAppear(){
            print("\n")
            print("Start date initiated as " + DateServer.printTime(inputTime: propertiesModel.startDate))
            initiateView()
        }
        .onChange(of: propertiesModel.startDate) { _ in
            print("\n")
            print("Start date changes to " + DateServer.printTime(inputTime: propertiesModel.startDate))
            initiateView()
            
        }
    }
}

//struct ScheduleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListView()
//    }
//}
