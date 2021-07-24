//
//  PropertiesModel.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/24/21.
//

import Foundation
import CoreData

class PropertiesModel: ObservableObject {
    @Published var totalScoreThisWeek:Int64 = 0
    @Published var gainedScoreThisWeek:Int64 = 0
    init(){
        updateScores()
    }
    
    func updateScores(){
        let beginDate = DateServer.startOfThisWeek()
        let endDate = beginDate + 604800
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Schedule> = Schedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(beginTime >= %@) AND (endTime < %@)", beginDate as NSDate, endDate as NSDate)
        do{
            let schedules = try managedObjectContext.fetch(fetchRequest)
            if schedules.count>0{
                var tempScore:Int64 = 0
                var tempGainedScore:Int64 = 0
                for r in 0..<schedules.count {
                    tempScore += schedules[r].score
                    tempGainedScore += schedules[r].scoreGained
                }
                totalScoreThisWeek = tempScore
                gainedScoreThisWeek = tempGainedScore
            } else {
                totalScoreThisWeek = 0
                gainedScoreThisWeek = 0
            }
        } catch{
            totalScoreThisWeek = 0
            gainedScoreThisWeek = 0
            print("Cannot get schedules for this week")
            print(error)
        }
    }
}
