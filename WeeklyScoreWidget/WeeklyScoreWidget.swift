//
//  WeeklyScoreWidget.swift
//  WeeklyScoreWidget
//
//  Created by Erda Wen on 8/24/21.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
    var managedObjectContext: NSManagedObjectContext
    
    init(context:NSManagedObjectContext){
        self.managedObjectContext = context
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(),schedules: [])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let fakeScheduleData = FakeScheduleProperitesData()
        let entry = SimpleEntry(date: Date(), configuration: configuration,schedules: fakeScheduleData.fakeData)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var wholeScheduleProperties:[ScheduleProperties] = []
        print("getTimeline")


        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        let fetchRequest = Schedule.schedulefetchRequest()
        fetchRequest.predicate =
            NSPredicate(format: "(endTime > %@) AND (endTime <= %@)", currentDate as NSDate, DateServer.addOneDay(date: DateServer.addOneDay(date: DateServer.startOfToday())) as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"endTime",ascending: true)]
        do{
            let schedules = try managedObjectContext.fetch(fetchRequest)
            // build up whole schedule list
            for schedule in schedules{
                var newScheduleProperty = ScheduleProperties()
                newScheduleProperty.beginTime =  schedule.beginTime
                newScheduleProperty.endTime = schedule.endTime
                newScheduleProperty.durationBased = schedule.items.durationBased
                newScheduleProperty.title = schedule.items.titleIcon + " " +  schedule.items.title
                newScheduleProperty.score = Int(schedule.score)
                newScheduleProperty.color = Color(schedule.items.tags.colorName)
                newScheduleProperty.colortext = Color(schedule.items.tags.colorName + "_text")
                wholeScheduleProperties.append(newScheduleProperty)
            }
            // fill in entries
            let newEntryDate = currentDate
            let newEntry = SimpleEntry(date: newEntryDate, configuration: configuration, schedules: wholeScheduleProperties)
            entries.append(newEntry)
            
            if wholeScheduleProperties.count > 0{
                let count = wholeScheduleProperties.count
                for _ in 1...count {
                    if schedules[0].endTime >= DateServer.addOneDay(date: DateServer.startOfToday()) {break}
                    let newEntryDate = schedules[0].endTime
                    wholeScheduleProperties.removeFirst()
                    let newEntry = SimpleEntry(date: newEntryDate, configuration: configuration, schedules: wholeScheduleProperties)
                    entries.append(newEntry)
                }
            }// if count>0

        } catch {
            print(error)
        }
        
            // check when new day starts
            let newEntryDate = DateServer.addOneDay(date: DateServer.startOfToday())
            let newEntry = SimpleEntry(date: newEntryDate, configuration: configuration, schedules: wholeScheduleProperties)
            entries.append(newEntry)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let schedules:[ScheduleProperties]
}

struct WeeklyScoreWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if entry.configuration.styles == .compact{
            WidgetScheduleContentView(schedules: entry.schedules,compact: true)
        } else {
            WidgetScheduleContentView(schedules: entry.schedules,compact: false)
        }
    }
}

@main
struct WeeklyScoreWidget: Widget {
    let kind: String = "WeeklyScoreWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(context: persistentContainer.viewContext)) { entry in
            WeeklyScoreWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Upcoming")
        .description("Show upcoming schedules for today and tommorrow.")
        .supportedFamilies([.systemSmall])
    }
    
    var persistentContainer:NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "WeeklyScore")
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.weeklySore.core.data")!
        let storeURL = containerURL.appendingPathComponent("DataModel.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

//struct WeeklyScoreWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        WeeklyScoreWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
