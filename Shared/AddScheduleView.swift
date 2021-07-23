//
//  AddEntryView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/7/21.
//

import SwiftUI

struct AddScheduleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var itemId = 0
    @State var inputScore:Int64 = 0
    @State var inputBeginTime = Date()
    @State var inputEndTime = Date()
    @State var showEndTimeWarning = false
    
    @Binding var addScheduleViewPresented:Bool
    
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
                            inputScore = items[itemId].defaultScore
                        })
                    }
                    // MARK: score (Stepper)
                    Stepper("Score: \(inputScore)", value: $inputScore, in: 0...20)
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
                    
                }.navigationBarTitle("Add New Schedule",displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action:{ addScheduleViewPresented = false}, label: {
                        Text("Cancel")
                    }), trailing: Button(action:{
                        items[itemId].lastUse = Date()
                        
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
                        do{
                            try viewContext.save()
                            print("Saved")
                            addScheduleViewPresented = false
                        } catch {
                            print("Cannot generate new item")
                            print(error)
                        }
                        
                    }, label: {
                        Text("Add")
                    }))
            } else {
                // Habit list is empty
                Text("No habit, add habit first")
            }
            
        }.onAppear(){
            itemId = 0
            inputScore = items[itemId].defaultScore
            inputBeginTime = DateServer.startOfThisWeek()
            inputEndTime = DateServer.startOfThisWeek() + 3600
        }
    }
}

struct AddEntryView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        AddScheduleView(addScheduleViewPresented:$dummyBool)
    }
}
