//
//  ScheduleListView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/26/21.
//

import SwiftUI

struct ScheduleListView: View {
    var startDate:Date

    @Environment(\.managedObjectContext) private var viewContext
    
    @State var schedules = [Schedule]()

    @State var completionViewPresented = false
    @State var changeViewPresented = false
    
    func initiateView() {
        let endDate = DateServer.addOneWeek(date: startDate)
        let fetchRequest = Schedule.schedulefetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(beginTime >= %@) AND (beginTime < %@)", startDate as NSDate, endDate as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "beginTime", ascending: true)]
        do {
            schedules = try viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
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
        .onAppear(){
            initiateView()
        }
    }
}

//struct ScheduleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListView()
//    }
//}
