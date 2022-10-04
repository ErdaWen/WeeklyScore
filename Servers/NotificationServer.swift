//
//  NotificationServer.swift
//  WeeklyScore (iOS)
//
//  Created by Erda Wen on 10/4/22.
//

import Foundation
import UserNotifications

class NotificationServer{
    static func askPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { success, error in
            if success{
                print("Success")
            } else if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    static func addNoitfication(of schedule:Schedule){
        let currentNotificationCenter = UNUserNotificationCenter.current()
        currentNotificationCenter.getNotificationSettings(completionHandler: { (settings) in
           if settings.authorizationStatus == .notDetermined {
              askPermission()
           } else if settings.authorizationStatus == .denied {
               askPermission()
           }
        })
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "\(schedule.items.titleIcon) \(schedule.items.title)"
        notificationContent.body = schedule.reminderTime==0 ? "Starting Now" : "Starting in \(schedule.reminderTime) mins"
        notificationContent.sound = UNNotificationSound.default
        
        let notificationTime = schedule.beginTime //.addingTimeInterval(TimeInterval(-360*schedule.reminderTime))
        let dateComponents = DateServer.generateDateComponents(of: notificationTime)
        let noitficationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: schedule.id!.uuidString, content: notificationContent, trigger: noitficationTrigger)
        currentNotificationCenter.add(notificationRequest)
    }
    
    static func debugNotification(){
        let currentNotificationCenter = UNUserNotificationCenter.current()
        currentNotificationCenter.getPendingNotificationRequests { requests in
            for request in requests{
                print(request)
            }
        }
    }
}
