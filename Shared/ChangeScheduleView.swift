//
//  ChangeScheduleView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/9/21.
//

import SwiftUI

struct ChangeScheduleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel

    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<Item>
    @Binding var changeScheduleViewPresented:Bool
    
    var schedule: Schedule
    
    let maxScore = max(UserDefaults.standard.integer(forKey: "maxScore"),10)
    
    @State var itemId = 0
    @State var inputScore:Int64 = 0
    @State var inputBeginTime = Date()
    @State var inputEndTime = Date()
    @State var showEndTimeWarning = false
    @State var inputReminder = false
    @State var inputReminderTime:Int64 = 0
    
    func initValues(){
        itemId = items.firstIndex(where: {$0.id == schedule.items.id}) ?? -1
        inputScore = schedule.score
        inputBeginTime = schedule.beginTime
        inputEndTime = schedule.endTime
        inputReminder = schedule.reminder
        inputReminderTime = schedule.reminderTime
    }
    
    func updateDefaulte () {
        inputScore = items[itemId].defaultScore
        inputBeginTime = DateServer.combineDayTime(day: Date(), time: items[itemId].defaultBeginTime)
        inputEndTime = inputBeginTime + Double(Int(items[itemId].defaultMinutes * 60))
    }
    
    func deleteSchedule(){
        items[itemId].scoreTotal -= schedule.scoreGained
        items[itemId].minutesTotal -= schedule.minutesGained
        items[itemId].checkedTotal -= schedule.checked ? 1 : 0
        viewContext.delete(schedule)
        do{
            changeScheduleViewPresented = false
            try viewContext.save()
            propertiesModel.updateScores()
            print("saved")
        } catch {
            print("Cannot generate new item")
            print(error)
        }
    }
    
    func saveSchedule(){
        
        items[itemId].lastUse = Date()
        items[itemId].defaultBeginTime = inputBeginTime
        items[itemId].defaultMinutes = Int64 ((inputEndTime.timeIntervalSince1970 - inputBeginTime.timeIntervalSince1970)/60)
        items[itemId].defaultScore = inputScore
        
            schedule.items = items[itemId]
            schedule.beginTime = inputBeginTime
            schedule.endTime = items[itemId].durationBased ? inputEndTime : inputBeginTime
            schedule.score = inputScore
            schedule.reminder = inputReminder
            schedule.reminderTime = inputReminderTime
            do{
                try viewContext.save()
                print("saved")
                propertiesModel.updateScores()
                changeScheduleViewPresented = false
            } catch {
                print("Cannot save item")
                print(error)
            }
    }
    
    var body: some View {
        NavigationView(){
            // Index may overflow when deleting the last element, need to check
            if itemId >= 0 {
                Form{
                    // If the schedule is checked, only delete function is allowed
                    if schedule.checked {
                        Text("Uncheck the schedule first")
                        
                    } else {
                        // The schedule is unchecked
                        // MARK: Habit list
                        HStack(){
                            Picker("Habbit",selection:$itemId){
                                ForEach(0...items.count-1, id:\.self){ r in
                                    Text(items[r].titleIcon+items[r].title)
                                        .tag(r)
                                }
                            }.onChange(of: itemId, perform: { value in
                                updateDefaulte ()
                            })
                        }
                        // MARK: score (Stepper)
                        Stepper("Score: \(inputScore)", value: $inputScore, in: 0...Int64(maxScore))
                        // MARK: begin time and end time picker
                        if items[itemId].durationBased {
                            DatePicker("Starts", selection: $inputBeginTime)
                            DatePicker("Ends", selection: $inputEndTime).onChange(of: inputEndTime, perform: { value in
                                if inputEndTime<inputBeginTime{
                                    inputEndTime = inputBeginTime
                                    showEndTimeWarning = true
                                } else {
                                    showEndTimeWarning = false
                                }
                            })
                            if showEndTimeWarning{
                                Text("Ends before it begins")
                            }
                        } else {
                            DatePicker("Time", selection: $inputBeginTime)
                        }
                        Toggle("Reminder", isOn:$inputReminder)
                        if inputReminder {
                            Picker("Remind in ",selection:$inputReminderTime){
                                Text("Happens").tag(0)
                                Text("5 min").tag(5)
                                Text("10 min").tag(10)
                                Text("15 min").tag(15)
                                Text("30 min").tag(30)
                                Text("45 min").tag(45)
                                Text("1 hour").tag(60)
                            }
                        }
                    }
                    
                    
                    Button(action:
                            {
                                deleteSchedule()
                            }, label: {
                                Text("Delete this event")
                            })
                    
                }.navigationBarTitle("Edit Schedule",displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action:{ changeScheduleViewPresented = false}, label: {
                        Text("Cancel")
                    }), trailing: Button(action:{
                        saveSchedule()
                    }, label: {
                        Text("Save")
                    }))
            } else {
                Text("Habit is archived")
            }
        }
        .onAppear(){
            initValues()
        }
        
    }
}

//struct ChangeScheduleView_Previews: PreviewProvider {
//    @State static var dummyBool = true
//    static var previews: some View {
//        ChangeScheduleView(changeScheduleViewPresented: $dummyBool, entryIndex: 1)
//    }
//}
