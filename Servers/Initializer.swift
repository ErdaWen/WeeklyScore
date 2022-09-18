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
        buildAttributes()

        buildData()
        do{
            try managedObjectContext.save()
            UserDefaults.standard.setValue(true, forKey: Constants.isDataPreloaded)
            print ("Data Initialized")
        } catch {
            print(error)
            print("Fail to initialize habits and schedules")
        }
    }
    
    func buildAttributes(){
        
        UserDefaults.standard.set(true, forKey: "nightMode")
        UserDefaults.standard.set(3,forKey:"weekStartDay")
        // Zoom in status in ListView
        UserDefaults.standard.set(false,forKey: "zoomedIn")
        // auto complete mode:
        // 0: mark as complete
        // 1: mark as incomplete
        // 3: mark as not recorded
        UserDefaults.standard.set(0, forKey: "autoCompleteMode")
        UserDefaults.standard.set(false,forKey: "showLocation")
        UserDefaults.standard.set(30, forKey: "maxScore")
        // Record whether shows calendar view by default
        UserDefaults.standard.set(true, forKey: "onDayView")
        UserDefaults.standard.set(12.5, forKey: "listScaleFactor")
        UserDefaults.standard.set(false, forKey: "previewMode")
        UserDefaults.standard.set(true, forKey: "showArchivedItem")
        UserDefaults.standard.set(true, forKey: "itemCatagorized")

    }
    
    func buildData(){
        let fetchRequest = Tag.tagFetchRequest()
        do{
            let existingTags = try managedObjectContext.fetch(fetchRequest)
            //if existingTags.count == 0 {
            if false{
                let tag_blue = Tag(context: managedObjectContext)
                tag_blue.id = UUID()
                tag_blue.name = "Health"
                tag_blue.colorName = "tag_color_blue"
                tag_blue.lastUse = Date()
                
                let tag_red = Tag(context: managedObjectContext)
                tag_red.id = UUID()
                tag_red.name = "Study"
                tag_red.colorName = "tag_color_red"
                tag_red.lastUse = Date()
                
                let item_study = Item(context: managedObjectContext)
                item_study.id = UUID()
                item_study.hidden = false
                item_study.titleIcon = "🗞"
                item_study.title = "Read Papers!"
                item_study.durationBased = true
                item_study.defaultScore = 20
                item_study.defaultMinutes = 180
                item_study.defaultBeginTime = DateServer.startOfToday() + 32400
                item_study.defaultReminder = false
                item_study.defaultReminderTime = 0
                item_study.checkedTotal = 1
                item_study.minutesTotal = 60
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
                item_workout.defaultBeginTime = DateServer.startOfToday() + 64800
                item_workout.defaultReminder = false
                item_workout.defaultReminderTime = 0
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
                item_getup.defaultBeginTime = DateServer.startOfToday() + 28800
                item_getup.defaultReminder = false
                item_getup.defaultReminderTime = 0
                item_getup.checkedTotal = 1
                item_getup.minutesTotal = 0
                item_getup.scoreTotal = 5
                item_getup.lastUse = Date()
                item_getup.tags = tag_blue
                
                let schedule_study = Schedule(context: managedObjectContext)
                schedule_study.id = UUID()
                schedule_study.items = item_study
                schedule_study.hidden = false
                schedule_study.beginTime = DateServer.startOfToday() + 32400
                schedule_study.endTime = DateServer.startOfToday() + 36000
                schedule_study.score = 10
                schedule_study.checked = true
                schedule_study.statusDefault = false
                schedule_study.minutesGained = 60
                schedule_study.scoreGained = 10
                schedule_study.reminder = false
                schedule_study.reminderTime = 0
                
                let schedule_getup = Schedule(context: managedObjectContext)
                schedule_getup.id = UUID()
                schedule_getup.items = item_getup
                schedule_getup.hidden = false
                schedule_getup.beginTime = DateServer.startOfToday() + 28800
                schedule_getup.endTime = DateServer.startOfToday() + 28800
                schedule_getup.score = 5
                schedule_getup.checked = true
                schedule_getup.statusDefault = false
                schedule_getup.minutesGained = 0
                schedule_getup.scoreGained = 5
                schedule_getup.reminder = false
                schedule_getup.reminderTime = 0
                    
            }
            
        } catch {
            print(error)
            print("cannot fetch existing tags")
        }
        
        
        
    }
    

}
