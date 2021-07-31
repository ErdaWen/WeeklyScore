//
//  ScheduleListEntry.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/31/21.
//

import SwiftUI

struct ScheduleListEntry: View {
    var startDate:Date
    var body: some View {
        ScheduleListView(schedules: FetchRequest(entity: Schedule.entity(), sortDescriptors: [NSSortDescriptor(key: "beginTime", ascending: true)]
                                                 , predicate: NSPredicate(format: "(beginTime >= %@) AND (beginTime < %@)", startDate as NSDate, DateServer.addOneWeek(date: startDate) as NSDate), animation: .default))
    }
}

//struct ScheduleListEntry_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListEntry()
//    }
//}
