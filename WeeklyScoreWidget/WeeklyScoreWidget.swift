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
        let entry = SimpleEntry(date: Date(), configuration: configuration,schedules: [])
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var wholeScheduleProperties:[ScheduleProperties] = []


        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        let fetchRequest = Schedule.schedulefetchRequest()
        fetchRequest.predicate =
            NSPredicate(format: "(endTime > %@) AND (beginTime <= %@)", currentDate as NSDate, DateServer.addOneWeek(date: DateServer.startOfThisWeek()) as NSDate)
        do{
            let schedules = try managedObjectContext.fetch(fetchRequest)
            // build up whole schedule list
            for schedule in schedules{
                var newScheduleProperty = ScheduleProperties()
                newScheduleProperty.beginTimeString = DateServer.printShortTime(inputTime: schedule.beginTime)
                newScheduleProperty.endTimeString = DateServer.printShortTime(inputTime: schedule.endTime)
                newScheduleProperty.durationBased = schedule.items.durationBased
                newScheduleProperty.title = schedule.items.titleIcon + " " +  schedule.items.title
                newScheduleProperty.score  = Int(schedule.score)
                wholeScheduleProperties.append(newScheduleProperty)
            }
            // fill in entries
            let newEntryDate = currentDate
            let newEntry = SimpleEntry(date: newEntryDate, configuration: configuration, schedules: wholeScheduleProperties)
            entries.append(newEntry)
            
            if wholeScheduleProperties.count > 0{
                let count = wholeScheduleProperties.count
                for _ in 1...count {
                    let newEntryDate = schedules[0].endTime
                    wholeScheduleProperties.removeFirst()
                    let newEntry = SimpleEntry(date: newEntryDate, configuration: configuration, schedules: wholeScheduleProperties)
                    entries.append(newEntry)
                }
            }// if count>0

        } catch {
            print(error)
        }
        
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
        WidgetScheduleContentView(schedules: entry.schedules)
    }
}

@main
struct WeeklyScoreWidget: Widget {
    let kind: String = "WeeklyScoreWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(context: PersistenceController.shared.container.viewContext)) { entry in
            WeeklyScoreWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Schedule Widget")
        .description("List the schedules.")
    }
    
}

//struct WeeklyScoreWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        WeeklyScoreWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
