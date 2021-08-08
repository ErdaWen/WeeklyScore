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
    @State var showConflictAlert = false
    
    @Binding var addScheduleViewPresented:Bool
    
    let mNavBar:CGFloat = 25
    let fsNavBar:CGFloat = 20
    let mVer:CGFloat = 20
    let mHor:CGFloat = 10
    let hField:CGFloat = 45
    
    
    func updateDefault () {
        inputScore = items[itemId].defaultScore
        inputBeginTime = DateServer.combineDayTime(day: initDate, time: items[itemId].defaultBeginTime)
        inputEndTime = items[itemId].durationBased ? inputBeginTime + Double(Int(items[itemId].defaultMinutes * 60)) : inputBeginTime
        inputReminder = items[itemId].defaultReminder
        inputReminderTime = items[itemId].defaultReminderTime
    }
    
    func checkScheduleConflict() -> Bool {
        var conflict = false
        let request = Schedule.schedulefetchRequest()
        request.predicate = NSPredicate(format: "(beginTime == %@) AND (endTime == %@)", inputBeginTime as NSDate, inputEndTime as NSDate)
        do {
            let results = try viewContext.fetch(request)
            if results.count > 0 {
                conflict = true
            }
        } catch {
            print(error)
        }
        return conflict
    }
    
    func saveSchedule() {
        items[itemId].lastUse = Date()
        items[itemId].defaultBeginTime = inputBeginTime
        items[itemId].defaultMinutes = Int64 ((inputEndTime.timeIntervalSince1970 - inputBeginTime.timeIntervalSince1970)/60)
        items[itemId].defaultScore = inputScore
        items[itemId].defaultReminder = inputReminder
        items[itemId].defaultReminderTime = inputReminderTime
        
        let newSchedule = Schedule(context: viewContext)
        newSchedule.id = UUID()
        newSchedule.beginTime = inputBeginTime
        newSchedule.endTime = items[itemId].durationBased ? inputEndTime : inputBeginTime
        newSchedule.items = items[itemId]
        newSchedule.score = inputScore
        newSchedule.reminder = inputReminder
        newSchedule.reminderTime = inputReminderTime
        
        newSchedule.hidden = false
        newSchedule.statusDefault = true
        newSchedule.checked = false
        newSchedule.scoreGained = 0
        newSchedule.minutesGained = 0
        
        do{
            try viewContext.save()
            print("Saved")
            propertiesModel.updateScores()
            propertiesModel.dumUpdate.toggle()
            addScheduleViewPresented = false
        } catch {
            print("Cannot generate new item")
            print(error)
        }
    }
    
    var body: some View {
        
        VStack{
            // MARK: Navigation Bar
            HStack{
                Button(action:{ addScheduleViewPresented = false}, label: {
                        Text("Discard")
                            .foregroundColor(Color("text_red")).font(.system(size: fsNavBar))
                })
                Spacer()
                Text("New Schedule").font(.system(size: fsNavBar))
                Spacer()
                
                Button(action:{
                    if checkScheduleConflict() {
                        showConflictAlert = true
                    } else {
                        saveSchedule()
                    }
                }, label: {
                    Text("   Add")
                        .foregroundColor(Color("text_blue")).font(.system(size: fsNavBar))
                })
                .alert(isPresented: $showConflictAlert) {
                    Alert(title: Text("😐 Time Conflict"), message: Text("Select another time"), dismissButton:.default(Text("OK"), action: {
                        showConflictAlert = false
                    }))
                }
            }.padding(mNavBar)
            
            ScrollView(){
                // If habit list is not empty
                if items.count != 0 {
                    
                    VStack(spacing:mVer){
                        // MARK: Habit picker

                        InputField(title: nil, alignment: .center, color: Color(items[itemId].tags.colorName), fieldHeight: nil) {
                            Picker("Habbit",selection:$itemId){
                                ForEach(0...items.count-1, id:\.self){ r in
                                    Text(items[r].titleIcon + items[r].title)
                                        .tag(r)
                                }
                            }.onChange(of: itemId, perform: { value in
                                updateDefault ()
                            })
                        }
                        
                        // MARK: score (Stepper)
                        InputField(title: nil, alignment: .center, color: Color(items[itemId].tags.colorName), fieldHeight: 40) {
                            Stepper("\(inputScore) pts", value: $inputScore, in: 0...Int64(maxScore))
                                .padding(8)
                        }
                        
                        
                        // MARK: begin time and end time picker
                        if items[itemId].durationBased {
                            InputField(title: nil, alignment: .center, color: Color(items[itemId].tags.colorName), fieldHeight: 40) {
                                DatePicker("Starts", selection: $inputBeginTime)
                                    .foregroundColor(Color("text_black"))
                                    .onChange(of: inputBeginTime, perform: { value in
                                    if inputEndTime<inputBeginTime{
                                        inputEndTime = inputBeginTime
                                    }
                                })
                                .padding(8)
                            }
                            InputField(title: nil, alignment: .center, color: Color(items[itemId].tags.colorName), fieldHeight: 40) {
                            DatePicker("Ends", selection: $inputEndTime).onChange(of: inputEndTime, perform: { value in
                                if inputEndTime<inputBeginTime{
                                    inputEndTime = inputBeginTime
                                    showEndTimeWarning = true
                                } else {
                                    showEndTimeWarning = false
                                }
                            })
                            }
                            if showEndTimeWarning{
                                Text("must ends after event begins")
                            }
                        } else {
                            DatePicker("Time", selection: $inputBeginTime)
                                .onChange(of: inputBeginTime) { _ in
                                    inputEndTime = inputBeginTime
                                }
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
                    } // end all VStack
                    .padding(.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                    
                    Form{
                        
                    }//end Form
                    .navigationBarTitle("Add New Schedule",displayMode: .inline)
                    .navigationBarItems(
                        leading: Button(action:{ addScheduleViewPresented = false}, label: {
                            Text("Cancel")
                        }), trailing: Button(action:{
                            
                            if checkScheduleConflict() {
                                showConflictAlert = true
                            } else {
                                saveSchedule()
                            }
                        }, label: {
                            Text("Add")
                        })
                        .alert(isPresented: $showConflictAlert) {
                            Alert(title: Text("😐 Time Conflict"), message: Text("Select another time"), dismissButton:.default(Text("OK"), action: {
                                showConflictAlert = false
                            }))
                        }
                    )
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
                    updateDefault ()
                }
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
