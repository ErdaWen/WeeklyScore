//
//  AddBatchDayScheduleView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/6/21.
//

import SwiftUI

struct AddBatchDayScheduleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    var dayStart:Date
    var schedules: FetchedResults<Schedule>
    @State var schedulesNextWeek:[Schedule] = []
    @State var numConflict = 0
    @Binding var addBatchDayScheduleViewPresented:Bool
    
    func createNewSchedule(schedule:Schedule){
        let newSchedule = Schedule(context: viewContext)
        newSchedule.id = UUID()
        newSchedule.beginTime = DateServer.addOneWeek(date: schedule.beginTime)
        // Some legacy hit-based items should ditch the endtime
        newSchedule.endTime = schedule.items.durationBased ? DateServer.addOneWeek(date: schedule.endTime) : DateServer.addOneWeek(date: schedule.beginTime)
        newSchedule.score = schedule.score
        newSchedule.location = schedule.location
        newSchedule.reminder = schedule.reminder
        newSchedule.reminderTime = schedule.reminderTime
        newSchedule.items = schedule.items
        
        newSchedule.hidden = false
        newSchedule.statusDefault = true
        newSchedule.checked = false
        newSchedule.scoreGained = 0
        newSchedule.minutesGained = 0
        
        do{
            try viewContext.save()
            print("Saved")
            propertiesModel.updateScores()
            propertiesModel.dumUpdate.toggle()
        } catch {
            print("Cannot copy new item")
            print(error)
        }
        
    }
    
    var body: some View {
        Button {
            for schedule in schedules {
                let schedulesConflict = schedulesNextWeek.filter { fschedule in
                    return (fschedule.beginTime == DateServer.addOneWeek(date: schedule.beginTime)) && (fschedule.endTime == DateServer.addOneWeek(date: schedule.endTime))
                }
                if schedulesConflict.count > 0 {
                    numConflict += 1
                } else {
                    createNewSchedule(schedule:schedule)
                }
                print(numConflict)
                addBatchDayScheduleViewPresented = false
            }
        } label: {
            Text("Copy")
        }.onAppear(){
//            let nextWeekToday = DateServer.addOneWeek(date: dayStart)
//            let nextWeekTodayEnd = DateServer.addOneDay(date: nextWeekToday)
//            let fetchRequest = Schedule.schedulefetchRequest()
//            fetchRequest.predicate =
//                NSPredicate(format: "(endTime >= %@) AND (begin <= %@)", nextWeekToday as NSDate, nextWeekTodayEnd as NSDate)
//            do {
//                schedulesNextWeek = try viewContext.fetch(fetchRequest)
//            } catch {
//                print(error)
//            }
        }

    }
}

//struct AddBatchScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddBatchScheduleView()
//    }
//}
