//
//  AutoRecordServer.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/4/21.
//

import Foundation

class AutoRecordServer {
    
    // return changed schedules
    static func autoRecord(mode: Int, weekStart: Date) -> [Schedule] {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let timeNow = Date()
        var changedSchedules:[Schedule] = []
        let fetchRequest = Schedule.schedulefetchRequest()
        fetchRequest.predicate =
            NSPredicate(format: "(beginTime >= %@) AND (endTime <= %@)", weekStart as NSDate, timeNow as NSDate)
        do{
            let schedules = try managedObjectContext.fetch(fetchRequest)
            for schedule in schedules {
                if schedule.statusDefault {
                    if mode == 0{
                        saveSchedule(schedule: schedule, inputChecked: true, inputScoreGained: schedule.score, inputMinutesGained: DateServer.getTotMin(beginTime: schedule.beginTime, endTime: schedule.endTime))
                    } else if mode == 1 {
                        saveSchedule(schedule: schedule, inputChecked: false, inputScoreGained: 0, inputMinutesGained: 0)
                    }
                    changedSchedules.append(schedule)
                }
            }
            // Save
            do{
                try managedObjectContext.save()
                print("change completion saved")
            } catch {
                print("Cannot save schedule")
                print(error)
            }

        } catch {
            print("Cannot get schedules")
            print(error)
        }

        return changedSchedules
    }
    
    static func saveSchedule(schedule:Schedule, inputChecked:Bool, inputScoreGained:Int64, inputMinutesGained:Int64) {
        
        // Execute change to habit for records
        schedule.items.checkedTotal += inputChecked ? 1 : 0
        schedule.items.scoreTotal += inputScoreGained
        schedule.items.minutesTotal += inputMinutesGained
        
        // Execute change to entry
        schedule.scoreGained = inputScoreGained
        schedule.minutesGained = inputMinutesGained
        schedule.checked = inputChecked
        schedule.statusDefault = false
    }
    
    
}
