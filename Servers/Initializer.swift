//
//  WholeModel.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/20/21.
//

import Foundation

class Initializer: ObservableObject{
    
    let managedObjectContext = PersistenceController.shared.container.viewContext
    
    init() {
        checkLoadedData()
    }
    
    func checkLoadedData() {
        let status = UserDefaults.standard.bool(forKey: Constants.isDataPreloaded)
        if status == false {
            preLoadData()
        }
    }
    
    func preLoadData() {
        buildData()
        do{
            try managedObjectContext.save()
            UserDefaults.standard.setValue(true, forKey: Constants.isDataPreloaded)
            print ("Initialized Data")
        } catch {
            print(error)
            print("Fail to initialize")
        }
    }
    
    func buildData(){
        let tag_red = Tag(context: managedObjectContext)
        tag_red.id = UUID()
        tag_red.name = "Carrer"
        tag_red.colorName = "tag_color_red"
        
        let tag_blue = Tag(context: managedObjectContext)
        tag_blue.id = UUID()
        tag_blue.name = "Carrer"
        tag_blue.colorName = "tag_color_blue"
        
        let item_study = Item(context: managedObjectContext)
        item_study.id = UUID()
        item_study.hidden = false
        item_study.titleIcon = "📚"
        item_study.title = "Study!"
        item_study.durationBased = true
        item_study.defaultScore = 20
        item_study.defaultMinutes = 120
        item_study.checkedTotal = 1
        item_study.minutesTotal = 120
        item_study.scoreTotal = 10
        item_study.lastUse = Date()
        item_study.tags = tag_red
        
        let item_workout = Item(context: managedObjectContext)
        item_workout.id = UUID()
        item_workout.hidden = false
        item_workout.titleIcon = "💪"
        item_workout.title = "Workout!"
        item_workout.durationBased = true
        item_workout.defaultMinutes = 60
        item_workout.defaultScore = 10
        item_workout.checkedTotal = 0
        item_workout.minutesTotal = 0
        item_workout.scoreTotal = 0
        item_workout.lastUse = Date()
        item_workout.tags = tag_blue

        let item_getup = Item(context: managedObjectContext)
        item_getup.id = UUID()
        item_getup.hidden = false
        item_getup.titleIcon = "☀️"
        item_getup.title = "Get up!"
        item_getup.durationBased = false
        item_getup.defaultMinutes = 0
        item_getup.defaultScore = 5
        item_getup.checkedTotal = 0
        item_getup.minutesTotal = 0
        item_getup.scoreTotal = 0
        item_getup.lastUse = Date()
        item_getup.tags = tag_blue
        
        let schedule_study = Schedule(context: managedObjectContext)
        schedule_study.id = UUID()
        schedule_study.items = item_study
        schedule_study.hidden = false
        schedule_study.beginTime = DateServer.startOfThisWeek() + 32400
        schedule_study.endTime = DateServer.startOfThisWeek() + 43200
        schedule_study.score = 20
        schedule_study.checked = true
        schedule_study.statusDefault = false
        schedule_study.minutesGained = 120
        schedule_study.scoreGained = 10
        
        let schedule_getup = Schedule(context: managedObjectContext)
        schedule_getup.id = UUID()
        schedule_getup.items = item_getup
        schedule_getup.hidden = false
        schedule_getup.beginTime = DateServer.startOfThisWeek() + 28800
        schedule_getup.endTime = DateServer.startOfThisWeek() + 28800
        schedule_getup.score = 0
        schedule_getup.checked = false
        schedule_getup.statusDefault = false
        schedule_getup.minutesGained = 0
        schedule_getup.scoreGained = 0
    }
}
