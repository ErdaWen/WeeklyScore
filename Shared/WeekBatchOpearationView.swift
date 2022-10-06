//
//  AddBatchDayScheduleView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/6/21.
//

import SwiftUI
import WidgetKit

struct WeekBatchOpearationView: View {
    enum ActiveAlert {
        case nothing, allFail, allDone, partDone
    }
    
    @AppStorage("nightMode") private var nightMode = true

    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    var dayStart:Date
    @FetchRequest var schedules: FetchedResults<Schedule>
    var singleDay: Bool
    
    
    @State var numConflict = 0
    @State var numDone = 0
    @Binding var addBatchScheduleViewPresented:Bool
    @State var showConflitAlert = false
    @State var showDeleteAlert = false
    @State var activeAlert: ActiveAlert = .allDone
    @State var weekCopyTo = Date()
    
    let mHorizon:CGFloat = 40
    let mNavBar:CGFloat = 25
    let fsNavBar:CGFloat = 20
    let fsForm:CGFloat = 16
    
    func copyAll(){
        for schedule in schedules {
            let combinedBeginTime = DateServer.combineWeekDay(week: weekCopyTo, time: schedule.beginTime)
            let combinedEndTime = DateServer.combineWeekDay(week: weekCopyTo, time: schedule.endTime)
            
            if ConflictServer.checkScheduleConflict(beginTime: combinedBeginTime, endTime: combinedEndTime, id: nil) {
                numConflict += 1
            } else {
                numDone += 1
                createNewSchedule(schedule:schedule,beginTime:combinedBeginTime,endTime:combinedEndTime)
            }
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func alarmConditioning() {
        if schedules.count == 0 {
            activeAlert = .nothing
        } else if numConflict == 0 {
            activeAlert = .allDone
        } else if numDone == 0 {
            activeAlert = .allFail
        } else {
            activeAlert = .partDone
        }

    }
        
    func createNewSchedule(schedule:Schedule,beginTime:Date,endTime:Date){
        let newSchedule = Schedule(context: viewContext)
        newSchedule.id = UUID()
        newSchedule.beginTime = beginTime
        // Some legacy hit-based items should ditch the endtime
        newSchedule.endTime = schedule.items.durationBased ? endTime : beginTime
        newSchedule.score = schedule.score
        newSchedule.location = schedule.location
        newSchedule.reminder = schedule.reminder
        newSchedule.reminderTime = schedule.reminderTime
        newSchedule.items = schedule.items
        
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
        } catch {
            print("Cannot copy new item")
            print(error)
        }
        if newSchedule.reminder{
            NotificationServer.addNotification(of: newSchedule)
            NotificationServer.debugNotification()
        }
        
    }
    
    func deleteAll(){
        for schedule in schedules {
            deleteSchedule(schedule:schedule)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func deleteSchedule(schedule:Schedule){
        schedule.items.scoreTotal -= schedule.scoreGained
        schedule.items.minutesTotal -= schedule.minutesGained
        schedule.items.checkedTotal -= schedule.checked ? 1 : 0
        viewContext.delete(schedule)
        do{
            try viewContext.save()
            propertiesModel.updateScores()
            print("all deleted")
        } catch {
            print("Cannot delete all")
            print(error)
        }
    }
    
    var body: some View {
        VStack{
            //MARK: Navigation bar
            HStack{
                Button {
                    addBatchScheduleViewPresented = false
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable().scaledToFit()
                        .foregroundColor(Color("text_black"))
                        .frame(height:25)
                }
                Spacer()
                Text("Batch Operation")
                    .font(.system(size: fsNavBar))
                Spacer()
                Spacer().frame(width: 25)
            }
            .frame(height:20)
            .padding(mNavBar)
            //Content:
            ScrollView{
                VStack(alignment: .center, spacing: 15 ){
                    //MARK: All habits view
                    InputField(title: nil, alignment: .leading, color: Color("background_grey2"), fieldHeight: 220) {
                        WeekBatchList(schedules: schedules)
                            .padding(.horizontal, 10)
                    }
                    .padding(.top,2)
                    //MARK: Select week
                    
                    
                    DatePicker("Copy to week of:", selection: $weekCopyTo,displayedComponents: .date)
                        .foregroundColor(Color("text_black"))
                        .font(.system(size: fsForm))
                        .datePickerStyle(CompactDatePickerStyle())
                        .onChange(of: weekCopyTo) { _ in
                            weekCopyTo = DateServer.startOfThisWeek(date: weekCopyTo)
                        }
                    
                    
//                    if weekCopyTo == DateServer.addOneWeek(date: DateServer.startOfThisWeek(date: Date())){
//
//                        HStack{
//                            Spacer()
//
//                            Text("(Next week)")
//                                .foregroundColor(Color("text_black"))
//                                .font(.system(size: fsForm))
//                        }
//
//                    }//end if
                    
                    
                    //MARK: Copy button
                    
                    Button {
                        copyAll()
                        alarmConditioning()
                        showConflitAlert = true
                        
                    } label: {
                        HStack{
                            Image(systemName: "doc.on.doc")
                                .resizable().scaledToFit()
                                .foregroundColor(Color("text_blue")).frame(height:20)
                            Text("Copy")
                                .foregroundColor(Color("text_blue"))
                                .font(.system(size: 20))
                        }
                    }//end button
                    .alert(isPresented: $showConflitAlert) {
                        switch activeAlert{
                        case .nothing:
                            return Alert(title: Text("😶 Nothing"), message: Text("Nothing to be copied") , dismissButton:.default(Text("OK"), action: {
                                showConflitAlert = false
                            }))
                        case .allDone:
                            return Alert(title: Text("✅ Done"), message: Text("\(numDone) " + (numDone == 1 ? "schedule " : "schedules ") + "copied."), dismissButton:.default(Text("OK"), action: {
                                addBatchScheduleViewPresented = false
                            }))
                        case .allFail:
                            return Alert(title: Text("❌ Conflit"), message: Text("No schedelue copied due to duplication with existing schedules"), dismissButton:.default(Text("OK"), action: {
                                addBatchScheduleViewPresented = false
                            }))
                        case .partDone:
                            return Alert(title: Text("⚠️ Conflit"), message: Text("\(numDone) " + (numDone == 1 ? "schedule " : "schedules ") + "copied. " + "\(numConflict) failed due to duplication with existing schedules"), dismissButton:.default(Text("OK"), action: {
                                addBatchScheduleViewPresented = false
                            }))
                            
                        }// end switch
                    }// end alert
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        HStack{
                            Image(systemName: "trash")
                                .resizable().scaledToFit()
                                .foregroundColor(Color("text_red")).frame(height:20)
                            Text("Delete All...")
                                .foregroundColor(Color("text_red"))
                                .font(.system(size: 20))
                        }
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        if schedules.count == 0{
                            return Alert(title: Text("😶 Nothing"), message: Text("Nothing to deleted") , dismissButton:.default(Text("OK"), action: {
                                showConflitAlert = false
                            }))
                        } else {
                            return Alert(title: Text("🤔 You Sure?"), message: Text("Delete all Schedules"), primaryButton: .default(Text("Keep"), action: {
                                showDeleteAlert = false
                            }), secondaryButton: .default(Text("Delete").foregroundColor(Color("text_red")), action: {
                                deleteAll()
                                showDeleteAlert = false
                                addBatchScheduleViewPresented = false
                            }))
                        }
                        
                    }
          
                    
                }// end content VStack
                .padding(.init(top: 0, leading: 20, bottom: 10, trailing: 20))
            }// end content scrollview
            
            
        }// end everything ZStack
        .onAppear(){
            weekCopyTo = DateServer.addOneWeek(date: DateServer.startOfThisWeek(date: Date()))
            
        }
        .preferredColorScheme(nightMode ? nil : .light)
        
    }
}

//struct AddBatchScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekBatchOpearationView()
//    }
//}
