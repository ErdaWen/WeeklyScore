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
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        //predicate:NSPredicate(format: "hidden == %@", "false"),
        animation: .default)
    private var items: FetchedResults<Item>
    @Binding var changeScheduleViewPresented:Bool
    
    var schedule: Schedule
    
    let maxScore = max(UserDefaults.standard.integer(forKey: "maxScore"),10)
    
    @State var itemId = -1
    @State var inputScore:Int64 = 0
    @State var inputBeginTime = Date()
    @State var inputEndTime = Date()
    @State var showEndTimeWarning = false
    @State var inputReminder = false
    @State var inputReminderTime:Int64 = 0
    @State var showConflictAlert = false
    @State var showDeleteAlert = false
    @State var inputNote = ""
    @State var itemsFiltered:[Item] = []
    
    let mNavBar:CGFloat = 25
    let fsNavBar:CGFloat = 20
    let mVer:CGFloat = 10
    let mHor:CGFloat = 15
    let hField:CGFloat = 45
    
    func initValues(){
        itemsFiltered = items.filter { item in
            return (item.hidden == false) || (item.id == schedule.items.id)
        }
        itemId = itemsFiltered.firstIndex(where: {$0.id == schedule.items.id}) ?? 0
        inputScore = schedule.score
        inputBeginTime = schedule.beginTime
        inputEndTime = schedule.endTime
        inputReminder = schedule.reminder
        inputReminderTime = schedule.reminderTime
        if let n = schedule.notes{
            inputNote = n
        }
    }
    
    func updateDefault () {
        inputScore = itemsFiltered[itemId].defaultScore
        inputEndTime = itemsFiltered[itemId].durationBased ? inputBeginTime + Double(Int(itemsFiltered[itemId].defaultMinutes * 60)) : inputBeginTime
    }
    
    func deleteSchedule(){
        itemsFiltered[itemId].scoreTotal -= schedule.scoreGained
        itemsFiltered[itemId].minutesTotal -= schedule.minutesGained
        itemsFiltered[itemId].checkedTotal -= schedule.checked ? 1 : 0
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
    
    func saveSchedule(){
        
        itemsFiltered[itemId].lastUse = Date()
        itemsFiltered[itemId].defaultBeginTime = inputBeginTime
        itemsFiltered[itemId].defaultMinutes = Int64 ((inputEndTime.timeIntervalSince1970 - inputBeginTime.timeIntervalSince1970)/60)
        itemsFiltered[itemId].defaultScore = inputScore
        itemsFiltered[itemId].defaultReminder = inputReminder
        itemsFiltered[itemId].defaultReminderTime = inputReminderTime
        
        schedule.items = itemsFiltered[itemId]
        schedule.beginTime = inputBeginTime
        schedule.endTime = itemsFiltered[itemId].durationBased ? inputEndTime : inputBeginTime
        schedule.score = inputScore
        schedule.reminder = inputReminder
        schedule.reminderTime = inputReminderTime
        schedule.notes = (inputNote == "" ? nil : inputNote)
        
        do{
            try viewContext.save()
            print("saved")
            propertiesModel.updateScores()
            propertiesModel.dumUpdate.toggle()
            changeScheduleViewPresented = false
        } catch {
            print("Cannot save item")
            print(error)
        }
    }
    
    var body: some View {
        VStack{
            if itemId < 0 {
                VStack(alignment:.center){
                    Spacer()
                    Text("❌ The habit is archieved. De-archive the habit to enable edit")
                        .font(.system(size: 16))
                        .foregroundColor(Color("text_black"))
                        .padding(5)
                    Button {
                        changeScheduleViewPresented = false
                    } label: {
                        Text("OK")
                            .font(.system(size: 20))
                            .foregroundColor(Color("text_blue"))
                            .padding(5)
                    }
                    Spacer()
                }.padding(40)
            } else {
                //Navigation Bar
                HStack{
                    Button(action:{ changeScheduleViewPresented = false}, label: {
                        Text("Cancel")
                            .foregroundColor(Color("text_red")).font(.system(size: fsNavBar))
                    })
                    Spacer()
                    Text("Edit Schedule").font(.system(size: fsNavBar))
                    Spacer()
                    Button(action:{
                        if checkScheduleConflict() {
                            showConflictAlert = true
                        } else {
                            saveSchedule()
                        }
                    }
                    , label: {
                        Text("Save")
                            .foregroundColor(Color("text_blue")).font(.system(size: fsNavBar))
                    })
                    .alert(isPresented: $showConflictAlert) {
                        Alert(title: Text("😐 Time Conflict"), message: Text("Select another time"), dismissButton:.default(Text("OK"), action: {
                            showConflictAlert = false
                        }))
                    }
                }.padding(mNavBar) // end Navigation bar
                
                ScrollView{
                    VStack(spacing:mVer){
                        // MARK: Habit picker
                        
                        InputField(title: nil, alignment: .center, color: Color(itemsFiltered[itemId].tags.colorName), fieldHeight: nil) {
                            Picker("Habbit",selection:$itemId){
                                ForEach(0...itemsFiltered.count-1, id:\.self){ r in
                                    Text(itemsFiltered[r].titleIcon + itemsFiltered[r].title)
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
                            .accentColor(Color(itemsFiltered[itemId].tags.colorName))
                        
                        // MARK: begin time and end time picker
                        if itemsFiltered[itemId].durationBased {
                            
                            DatePicker("Starts", selection: $inputBeginTime)
                                .foregroundColor(Color("text_black"))
                                .accentColor(Color(itemsFiltered[itemId].tags.colorName))
                                .onChange(of: inputBeginTime, perform: { _ in
                                    inputEndTime = inputBeginTime + Double(60 * itemsFiltered[itemId].defaultMinutes)
                                })
                            
                            DatePicker("Ends", selection: $inputEndTime)
                                .foregroundColor(Color("text_black"))
                                .accentColor(Color(itemsFiltered[itemId].tags.colorName))
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
                                .accentColor(Color(itemsFiltered[itemId].tags.colorName))
                                .onChange(of: inputBeginTime) { _ in
                                    inputEndTime = inputBeginTime
                                }
                        }
                        //MARK: Reminder
                        Toggle("Reminder", isOn:$inputReminder)
                            .foregroundColor(Color("text_black"))
                            .toggleStyle(SwitchToggleStyle(tint: Color(itemsFiltered[itemId].tags.colorName)))
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
                            .foregroundColor(Color(itemsFiltered[itemId].tags.colorName))
                            .pickerStyle(MenuPickerStyle())
                            .animation(.default)
                        }
                        Spacer().frame(height:8)
                        InputField(title: "Notes", alignment: .leading, color: Color(items[itemId].tags.colorName), fieldHeight: 180) {
                            TextEditor(text: $inputNote)
                                .font(.system(size: 15))
                                .foregroundColor(Color("text_black"))
                                .padding(5)
                        }.animation(.default)
                        //MARK: Delete schedule
                        
                        Button("Delete Schedule...") {
                            // MARK: warning to be added
                            showDeleteAlert = true
                        }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(title: Text("🤔 You Sure?"), message: Text("Delete this schedule?"), primaryButton: .default(Text("Keep"), action: {
                                showDeleteAlert = false
                            }), secondaryButton: .default(Text("Delete!"), action: {
                                deleteSchedule()
                                changeScheduleViewPresented = false
                            }))
                        }
                        .foregroundColor(Color("text_red"))
                        .font(.system(size: 20))
                        
                    } // end form VStack
                    .padding(.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                }// end scrollView
                
            }// end if no item
        }// end total Vstack
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
