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
    @State var inputReminderTime = 0
    @State var showEndTimeWarning = false
    @State var showConflictAlert = false
    @State var inputNote = ""
    
    @Binding var addScheduleViewPresented:Bool
    
    let mNavBar:CGFloat = 25
    let fsNavBar:CGFloat = 20
    let mVer:CGFloat = 10
    let mHor:CGFloat = 15
    let hField:CGFloat = 45
    
    
    func updateDefault () {
        inputScore = items[itemId].defaultScore
        inputBeginTime = DateServer.combineDayTime(day: initDate, time: items[itemId].defaultBeginTime)
        inputEndTime = items[itemId].durationBased ? inputBeginTime + Double(Int(items[itemId].defaultMinutes * 60)) : inputBeginTime
        inputReminder = items[itemId].defaultReminder
        inputReminderTime = Int(items[itemId].defaultReminderTime)
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
        items[itemId].defaultReminderTime = Int64(inputReminderTime)
        
        let newSchedule = Schedule(context: viewContext)
        newSchedule.id = UUID()
        newSchedule.beginTime = inputBeginTime
        newSchedule.endTime = items[itemId].durationBased ? inputEndTime : inputBeginTime
        newSchedule.items = items[itemId]
        newSchedule.score = inputScore
        newSchedule.reminder = inputReminder
        newSchedule.reminderTime = Int64(inputReminderTime)
        newSchedule.notes = (inputNote == "" ? nil : inputNote)
        
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
            
            if items.count == 0 {
                VStack{
                    Spacer()
                    Text("❌ You have no active habits, add/de-archive habit first")
                        .font(.system(size: 20))
                        .foregroundColor(Color("text_blue"))
                        .padding(5)
                    Button {
                        addScheduleViewPresented = false
                    } label: {
                        Text("OK")
                            .font(.system(size: 20))
                            .foregroundColor(Color("text_blue"))
                            .padding(5)
                    }
                    Spacer()
                }
            } else {
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
                                            .font(.system(size: 20))
                                            .fontWeight(.light)
                                            .foregroundColor(Color("text_black"))
                                            .tag(r)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .onChange(of: itemId, perform: { value in
                                    updateDefault ()
                                })
                            }
                            
                            // MARK: score (Stepper)
                            
                            Stepper("Score: \(inputScore) pts", value: $inputScore, in: 0...Int64(maxScore))
                                .foregroundColor(Color("text_black"))
                                .accentColor(Color(items[itemId].tags.colorName))
                            
                            // MARK: begin time and end time picker
                            if items[itemId].durationBased {
                                
                                DatePicker("Starts", selection: $inputBeginTime)
                                    .foregroundColor(Color("text_black"))
                                    .accentColor(Color(items[itemId].tags.colorName))
                                    .onChange(of: inputBeginTime, perform: { _ in
                                        inputEndTime = inputBeginTime + Double(60 * items[itemId].defaultMinutes)
                                    })
                                
                                DatePicker("Ends", selection: $inputEndTime)
                                    .foregroundColor(Color("text_black"))
                                    .accentColor(Color(items[itemId].tags.colorName))
                                    .onChange(of: inputEndTime, perform: { value in
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
                                    .foregroundColor(Color("text_black"))
                                    .accentColor(Color(items[itemId].tags.colorName))
                                    .onChange(of: inputBeginTime) { _ in
                                        inputEndTime = inputBeginTime
                                    }
                            }
                            //MARK: Reminder
                            Toggle("Reminder", isOn:$inputReminder)
                                .foregroundColor(Color("text_black"))
                                .toggleStyle(SwitchToggleStyle(tint: Color(items[itemId].tags.colorName)))
                                .animation(.default)

                            if inputReminder {
                                Picker("Remind " + (inputReminderTime == 0 ? "when happens..." : "in \(inputReminderTime) min...") ,selection:$inputReminderTime){
                                    Text("when happens").tag(0)
                                    Text("in 5 min").tag(5)
                                    Text("in 10 min").tag(10)
                                    Text("in 15 min").tag(15)
                                    Text("in 30 min").tag(30)
                                    Text("in 45 min").tag(45)
                                    Text("in 1 hour").tag(60)
                                }
                                .foregroundColor(Color(items[itemId].tags.colorName))
                                .pickerStyle(MenuPickerStyle())
                                .animation(.default)
                            }
                            Spacer().frame(height:20)
                            InputField(title: "Notes", alignment: .leading, color: Color(items[itemId].tags.colorName), fieldHeight: 180) {
                                TextEditor(text: $inputNote)
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("text_black"))
                                    .padding(5)
                            }.animation(.default)
                            
                        } // end form VStack
                        .padding(.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                        
                    } else {
                        // Habit list is empty
                        
                    }
                    
                } // end ScrollView
            } // end if no habit
        }// end total VStack
        .onAppear(){
            if items.count > 0{
                itemId = 0
                updateDefault ()
            }
        }// end onAppear
    }
}

//struct AddEntryView_Previews: PreviewProvider {
//    @State static var dummyBool = true
//    static var previews: some View {
//        AddScheduleView(addScheduleViewPresented:$dummyBool)
//    }
//}
