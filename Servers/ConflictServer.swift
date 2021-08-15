//
//  ConflictServer.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/14/21.
//

import Foundation

// for new schedule, input nil as id
class ConflictServer {
    static func checkScheduleConflict(beginTime:Date,endTime:Date,id:UUID?) -> Bool {
        var conflict = false
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let request = Schedule.schedulefetchRequest()
        request.predicate = NSPredicate(format: "(beginTime == %@) AND (endTime == %@)", beginTime as NSDate, endTime as NSDate)
        do {
            let results = try managedObjectContext.fetch(request)
            if results.count > 0 {
                conflict = true
            }
            // the only result is itself
            if (results.count == 1) && (results[0].id == id) {
                // Cannot conflict with itself
                conflict = false
            }
        } catch {
            print(error)
        }
        return conflict
    }
}
