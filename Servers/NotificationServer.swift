//
//  NotificationServer.swift
//  WeeklyScore (iOS)
//
//  Created by Erda Wen on 10/4/22.
//

import Foundation
import UserNotifications

class NotificationServer{
    static func askPermission() -> Bool{
        var grantSuccess = false
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { granted, error in
            if granted{
               grantSuccess = true
            } else if let error = error{
                print(error.localizedDescription)
            }
        }
        return grantSuccess
    }
    
    static func checkPermission() -> Bool{
        var grantSuccess = true
        let currentNotificationCenter = UNUserNotificationCenter.current()
        currentNotificationCenter.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .denied {
                grantSuccess = false
            } else if settings.authorizationStatus == .notDetermined{
                grantSuccess = false
            }
        })
        return grantSuccess
    }
    
    static func addNotification(of schedule:Schedule){
        let currentNotificationCenter = UNUserNotificationCenter.current()
        
        currentNotificationCenter.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .denied {
                askPermission()
            } else if settings.authorizationStatus == .notDetermined{
                askPermission()
            }
        })

        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "\(schedule.items.titleIcon) \(schedule.items.title)"
        notificationContent.body = schedule.reminderTime==0 ? "Starting Now." : "Starting in \(schedule.reminderTime) mins."
        if schedule.score>0{
            notificationContent.body += "\(schedule.score)"
            notificationContent.body += schedule.score==1 ? "pt": "pts"
        }
        notificationContent.sound = UNNotificationSound.default
        
        let notificationTime = schedule.beginTime.addingTimeInterval(TimeInterval(-360*schedule.reminderTime))
        let dateComponents = DateServer.generateDateComponents(of: notificationTime)
        let noitficationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: schedule.id!.uuidString, content: notificationContent, trigger: noitficationTrigger)
        currentNotificationCenter.add(notificationRequest)
    }
    
    static func removeNotification(of schedule:Schedule){
        let currentNotificationCenter = UNUserNotificationCenter.current()
        currentNotificationCenter.removePendingNotificationRequests(withIdentifiers: [schedule.id!.uuidString])
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
