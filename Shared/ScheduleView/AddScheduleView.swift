//
//  AddEntryView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/7/21.
//

import SwiftUI

struct AddScheduleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    var initDate: Date
    
    let maxScore = max(UserDefaults.standard.integer(forKey: "maxScore"),10)
    
    @State var itemId = 0
    @State var inputScore:Int64 = 0
    @State var inputBeginTime = Date()
    @State var inputEndTime = Date()
    @State var inputReminder = false
    @State var inputReminderTime:Int64 = 0
    @State var showEndTimeWarning = false
    
    @Binding var addScheduleViewPresented:Bool
    
    
    func updateDefaulte () {
        inputScore = items[itemId].defaultScore
        inputBeginTime = DateServer.combineDayTime(day: initDate, time: items[itemId].defaultBeginTime)
        inputEndTime = inputBeginTime + Double(Int(items[itemId].defaultMinutes * 60))
    }
    
    func saveSchedule() {
        items[itemId].lastUse = Date()
        items[itemId].defaultBeginTime = inputBeginTime
        items[itemId].defaultMinutes = Int64 ((inputEndTime.timeIntervalSince1970 - inputBeginTime.timeIntervalSince1970)/60)
        items[itemId].defaultScore = inputScore
        
        let newSchedule = Schedule(context: viewContext)
        newSchedule.id = UUID()
        newSchedule.beginTime = inputBeginTime
        newSchedule.endTime = items[itemId].durationBased ? inputEndTime : inputBeginTime
        newSchedule.items = items[itemId]
        newSchedule.score = inputScore
        newSchedule.hidden = false
        newSchedule.statusDefault = true
        newSchedule.checked = false
        newSchedule.scoreGained = 0
        newSchedule.minutesGained = 0
        newSchedule.reminder = inputReminder
        newSchedule.reminderTime = inputReminderTime
        do{
            try viewContext.save()
            print("Saved")
            propertiesModel.updateScores()
            addScheduleViewPresented = false
        } catch {
            print("Cannot generate new item")
            print(error)
        }
    }
    
    var body: some View {
        
        NavigationView(){
            // If habit list is not empty
            if items.count != 0 {
                Form{
                    // MARK: Habit list
                    HStack(){
                        Picker("Habbit",selection:$itemId){
                            ForEach(0...items.count-1, id:\.self){ r in
                                Text(items[r].titleIcon + items[r].title)
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
                        DatePicker("Starts", selection: $inputBeginTime).onChange(of: inputBeginTime, perform: { value in
                            if inputEndTime<inputBeginTime{
                                inputEndTime = inputBeginTime
                            }
                        })
                        DatePicker("Ends", selection: $inputEndTime).onChange(of: inputEndTime, perform: { value in
                            if inputEndTime<inputBeginTime{
                                inputEndTime = inputBeginTime
                                showEndTimeWarning = true
                            } else {
                                showEndTimeWarning = false
                            }
                        })
                        if showEndTimeWarning{
                            Text("must ends after event begins")
                        }
                    } else {
                        DatePicker("Time", selection: $inputBeginTime)
                    }
                    //MARK: Reminder
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
                }.navigationBarTitle("Add New Schedule",displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action:{ addScheduleViewPresented = false}, label: {
                        Text("Cancel")
                    }), trailing: Button(action:{
                        saveSchedule()
                        
                    }, label: {
                        Text("Add")
                    }))
            } else {
                // Habit list is empty
                VStack{
                    Text("You have no habits, add habit first")
                    Button {
                        addScheduleViewPresented = false
                    } label: {
                        Text("OK")
                    }

                }
            }
            
        }.onAppear(){
            if items.count > 0{
                itemId = 0
                updateDefaulte ()
            }
        }
    }
}

//struct AddEntryView_Previews: PreviewProvider {
//    @State static var dummyBool = true
//    static var previews: some View {
//        AddScheduleView(addScheduleViewPresented:$dummyBool)
//    }
//}
