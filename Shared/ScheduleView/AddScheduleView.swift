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
    @AppStorage("nightMode") private var nightMode = true

    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
       // predicate:NSPredicate(format: "hidden == %@", "false"),
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
    @State var itemsFiltered:[Item] = []
    
    @State var addViewPresented = false
    
    @Binding var addScheduleViewPresented:Bool
    
    let mNavBar:CGFloat = 25
    let fsNavBar:CGFloat = 20
    let mVer:CGFloat = 10
    let mHor:CGFloat = 15
    let hField:CGFloat = 45
    let sButton:CGFloat = 22
    
    func initValues(){
        itemsFiltered = items.filter { item in
            return item.hidden == false
        }
        if itemsFiltered.count > 0{
            itemId = 0
            updateDefault ()
        }
    }
    
    
    func updateDefault () {
        inputScore = itemsFiltered[itemId].defaultScore
        inputBeginTime = DateServer.combineDayTime(day: initDate, time: itemsFiltered[itemId].defaultBeginTime)
        inputEndTime = itemsFiltered[itemId].durationBased ? inputBeginTime + Double(Int(itemsFiltered[itemId].defaultMinutes * 60)) : inputBeginTime
        inputReminder = itemsFiltered[itemId].defaultReminder
        inputReminderTime = Int(itemsFiltered[itemId].defaultReminderTime)
    }
    
    func saveSchedule() {
        itemsFiltered[itemId].lastUse = Date()
        itemsFiltered[itemId].defaultBeginTime = inputBeginTime
        itemsFiltered[itemId].defaultMinutes = Int64 ((inputEndTime.timeIntervalSince1970 - inputBeginTime.timeIntervalSince1970)/60)
        itemsFiltered[itemId].defaultScore = inputScore
        itemsFiltered[itemId].defaultReminder = inputReminder
        itemsFiltered[itemId].defaultReminderTime = Int64(inputReminderTime)
        
        let newSchedule = Schedule(context: viewContext)
        newSchedule.id = UUID()
        newSchedule.beginTime = inputBeginTime
        newSchedule.endTime = itemsFiltered[itemId].durationBased ? inputEndTime : inputBeginTime
        newSchedule.items = itemsFiltered[itemId]
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
            
            if itemsFiltered.count == 0 {
                VStack(alignment:.center){
                    HStack{
                        Button {
                            addScheduleViewPresented = false
                        } label: {
                            Image(systemName: "xmark.circle")
                                .resizable().scaledToFit()
                                .foregroundColor(Color("text_black"))
                                .frame(height:25)
                        }
                        Spacer()
                    }.padding(mNavBar)
                    Spacer()
                    Text("🌵 You have no active habits. Start by adding one:")
                        .font(.system(size: 16))
                        .foregroundColor(Color("text_black"))
                        .padding(.horizontal,40)
                    FloatButton(systemName: "plus.square", sButton: sButton) {
                        addViewPresented = true
                    }
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                    .sheet(isPresented: $addViewPresented, content: {
                        AddItemView(addItemViewPresented: $addViewPresented)
                            .environment(\.managedObjectContext,self.viewContext)
                    }).padding(mNavBar)
                    .onChange(of: items.count) { _ in
                        initValues()
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
                        if ConflictServer.checkScheduleConflict(beginTime: inputBeginTime, endTime: inputEndTime, id: nil) {
                            showConflictAlert = true
                        } else {
                            saveSchedule()
                        }
                    }, label: {
                        Text("   Add")
                            .foregroundColor(Color("text_blue")).font(.system(size: fsNavBar)).fontWeight(.semibold)
                    })
                    .alert(isPresented: $showConflictAlert) {
                        Alert(title: Text("😐 Time Conflict"), message: Text("Select another time"), dismissButton:.default(Text("OK"), action: {
                            showConflictAlert = false
                        }))
                    }
                }.padding(mNavBar)
                
                ScrollView(){
                    // If habit list is not empty
                        
                        VStack(spacing:mVer){
                            // MARK: Habit picker
                            
                            InputField(title: nil, alignment: .center, color: Color(itemsFiltered[itemId].tags.colorName), fieldHeight: nil) {
                                
                                ZStack(alignment: .bottomTrailing){
                                    
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
                                    .onChange(of: items.count) { _ in
                                        initValues()
                                    }
                                    
                                    FloatButton(systemName: "plus.square", sButton: sButton) {
                                        addViewPresented = true
                                    }
                                    .padding(.trailing, 10)
                                    .padding(.bottom, 10)
                                    .sheet(isPresented: $addViewPresented, content: {
                                        AddItemView(addItemViewPresented: $addViewPresented)
                                            .environment(\.managedObjectContext,self.viewContext)
                                    })
                                }
                            }.padding(.top, 2)
                            
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
                                
                                DatePicker("Ends", selection: $inputEndTime, in: inputBeginTime...)
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
                            Spacer().frame(height:20)
                            InputField(title: "Notes", alignment: .leading, color: Color(itemsFiltered[itemId].tags.colorName), fieldHeight: 180) {
                                ZStack(alignment:.center){
                                    TextEditor(text: $inputNote)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color("text_black"))
                                    if inputNote.isEmpty{
                                        Text("Jog down goals, subtasks, journals...")
                                            .font(.system(size: 15))
                                            .foregroundColor(Color("text_black").opacity(0.5))
                                    }
                                }.padding(5)
                            }.animation(.default)
                            
                        } // end form VStack
                        .padding(.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                        
                    
                    
                } // end ScrollView
            } // end if no habit
        }// end total VStack
        .onAppear(){
            initValues()
        }// end onAppear
        .preferredColorScheme(nightMode ? nil : .light)
    }
}

//struct AddEntryView_Previews: PreviewProvider {
//    @State static var dummyBool = true
//    static var previews: some View {
//        AddScheduleView(addScheduleViewPresented:$dummyBool)
//    }
//}
