//
//  ScheduleDetailView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/8/21.
//

import SwiftUI

struct ScheduleDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel

    
    var schedule: Schedule
    @Binding var scheduleDetailViewPresented: Bool
    
    @State var inputNote = ""
    @State var showSaveNote = false
    @State var showDeleteAlert = false
    @State var showCheckedAlert = false
    @State var changeViewPresented = false
    
    let mNavBar:CGFloat = 15
    let fsNavBar:CGFloat = 20
    let mVer:CGFloat = 10
    let mHor:CGFloat = 15
    
    func saveNote() {
        schedule.notes = inputNote
        do{
            try viewContext.save()
            scheduleDetailViewPresented = false
            print("saved")
        } catch {
            print("Cannot generate new item")
            print(error)
        }
    }
    
    func deleteSchedule(){
        schedule.items.scoreTotal -= schedule.scoreGained
        schedule.items.minutesTotal -= schedule.minutesGained
        schedule.items.checkedTotal -= schedule.checked ? 1 : 0
        viewContext.delete(schedule)
        do{
            scheduleDetailViewPresented = false
            try viewContext.save()
            propertiesModel.updateScores()
            print("saved")
        } catch {
            print("Cannot generate new item")
            print(error)
        }
    }
    
    func initValues(){
        if let n = schedule.notes{
            inputNote = n
        }
    }

    var body: some View {
        VStack{
            //MARK: Navigation Bar
            HStack{
                //MARK: Save Note Button
                if showSaveNote {
                    Button(action:{
                        saveNote()
                    }
                    , label: {
                        Text("Save Notes")
                            .foregroundColor(Color("text_blue")).font(.system(size: fsNavBar))
                    })
                } else {
                    Button(action:{
                        scheduleDetailViewPresented = false
                    }
                    , label: {
                        Image(systemName: "chevron.backward")
                            .resizable().scaledToFit()
                            .foregroundColor(Color("text_blue"))
                            .frame(height:22)
                    })
                }
                Spacer()
                Button(action:{
                    if schedule.checked {
                        showCheckedAlert = true
                    } else {
                        changeViewPresented = true
                    }
                }
                , label: {
                    Text("Edit")
                        .foregroundColor(Color("text_blue")).font(.system(size: fsNavBar))
                })
                .alert(isPresented: $showCheckedAlert) {
                    Alert(title: Text("❌ Schedule checked"), message: Text("Uncheck the schedule first to allow edit"), dismissButton:.default(Text("OK"), action: {
                        showCheckedAlert = false
                    }))
                }.sheet(isPresented: $changeViewPresented) {
                    ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, schedule: schedule)
                }
            }.padding(mNavBar)
            //MARK: Content Scroll
            ScrollView{
                if schedule.id != nil{
                    VStack(spacing:mVer){
                        ScheduleTileDetailView(schedule: schedule)
                            .frame(height:CordServer.calculateHeight(startTime: schedule.beginTime, endTime: schedule.endTime, factor: 50, minHeight: 100, maxHeight: 250))
                        
                        InputField(title: "Notes", alignment: .leading, color: Color(schedule.items.tags.colorName), fieldHeight: 250) {
                            TextEditor(text: $inputNote)
                                .font(.system(size: 15))
                                .foregroundColor(Color("text_black"))
                                .padding(5)
                        }
                        .padding(.vertical,10)
                        .padding(.horizontal,20)
                        .animation(.default)
                        .onChange(of: inputNote) { _ in
                            showSaveNote = true
                        }
                        
                        Button("Delete Schedule...") {
                            // MARK: warning to be added
                            showDeleteAlert = true
                        }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(title: Text("🤔 You Sure?"), message: Text("Delete this schedule?"), primaryButton: .default(Text("Keep"), action: {
                                showDeleteAlert = false
                            }), secondaryButton: .default(Text("Delete!"), action: {
                                deleteSchedule()
                                scheduleDetailViewPresented = false
                            }))
                        }
                        .foregroundColor(Color("text_red"))
                        .font(.system(size: 20))
     
                    }//end content VStack
                    .padding(.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                }
            }//end ScrollView
        }// end everything VStack
        .onAppear(){
            initValues()
        }
        .animation(.default)
    }
}

//struct ScheduleDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDetailView()
//    }
//}
