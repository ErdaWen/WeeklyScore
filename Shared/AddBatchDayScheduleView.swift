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
    
    @State var numConflict = 0
    @Binding var addBatchDayScheduleViewPresented:Bool
    @State var showConflitAlert = false
    
    
    func checkScheduleConflict(schedule:Schedule) -> Bool {
        var conflict = false
        let newBeginTime = DateServer.addOneWeek(date: schedule.beginTime)
        let newEndTime = schedule.items.durationBased ? DateServer.addOneWeek(date: schedule.endTime) : DateServer.addOneWeek(date: schedule.beginTime)
        let request = Schedule.schedulefetchRequest()
        request.predicate = NSPredicate(format: "(beginTime == %@) AND (endTime == %@)", newBeginTime as NSDate, newEndTime as NSDate)
        do {
            let results = try viewContext.fetch(request)
            if results.count > 0 {
                conflict = true
            }
        } catch {
            print(error)
        }
        return conflict
    }
    
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
                if checkScheduleConflict(schedule:schedule) {
                    numConflict += 1
                } else {
                    createNewSchedule(schedule:schedule)
                }
            }
            if numConflict > 0 {
               showConflitAlert = true
            } else {
                addBatchDayScheduleViewPresented = false
            }
            
        } label: {
            Text("Copy to next week")
        }.alert(isPresented: $showConflitAlert) {
            Alert(title: Text("Conflict"), message: Text("\(numConflict) " + (numConflict == 1 ? "schedule " : "schedules ") + " failed to be created due to conflict with existing schedules"), dismissButton:.default(Text("OK"), action: {
                addBatchDayScheduleViewPresented = false
            }))
        }
    }
}

//struct AddBatchScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddBatchScheduleView()
//    }
//}
