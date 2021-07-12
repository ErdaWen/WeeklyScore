//
//  ChangeScheduleView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/9/21.
//

import SwiftUI

struct ChangeScheduleView: View {
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    @Binding var changeScheduleViewPresented:Bool
    
    var entryIndex: Int
    
    @State var inputHabitidpos = 0
    @State var inputScore = 0
    @State var inputBeginTime = Date()
    @State var inputEndTime = Date()
    @State var showEndTimeWarning = false
    
    
    
    var body: some View {
        NavigationView(){
            // entryIndex may overflow when deleting the last element, need to check
            if entryIndex<entryModel.entries.count{
                Form{
                    // When deleting the last element, entryIndex may overflow
                    
                    if entryModel.entries[entryIndex].checked {
                        Text("Uncheck the schedule first")
                        Button(action:
                                {
                                    habitModel.habits[inputHabitidpos].changeHours(inScoreAdded: -entryModel.entries[entryIndex].scoreGained, inHoursAdded: -entryModel.entries[entryIndex].hoursGained, inCheckedAdded: entryModel.entries[entryIndex].checked ? -1 : 0)
                                    entryModel.deleteEntry(indexing: entryIndex)
                                    changeScheduleViewPresented = false
                                }, label: {
                                    Text("Delete this event")
                                })
                        
                    } else {
                        // MARK: Habit list
                        HStack(){
                            Picker("Habbit",selection:$inputHabitidpos){
                                ForEach(0...habitModel.habits.count-1, id:\.self){ r in
                                    Text(habitModel.habits[r].titleIcon+habitModel.habits[r].title)
                                        .tag(r)
                                }
                            }.onChange(of: inputHabitidpos, perform: { value in
                                inputScore = habitModel.habits[inputHabitidpos].defaultScore
                            })
                        }
                        // MARK: score (Stepper)
                        Stepper("Score: \(inputScore)", value: $inputScore, in: 0...20)
                        // MARK: begin time and end time picker
                        if habitModel.habits[inputHabitidpos].durationBased {
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
                        // MARK: Delete schedule
                        Button(action:
                                {
                                    changeScheduleViewPresented = false
                                    habitModel.habits[inputHabitidpos].changeHours(inScoreAdded: -entryModel.entries[entryIndex].scoreGained, inHoursAdded: -entryModel.entries[entryIndex].hoursGained, inCheckedAdded: entryModel.entries[entryIndex].checked ? -1 : 0)
                                    entryModel.deleteEntry(indexing: entryIndex)
                                }, label: {
                                    Text("Delete this event")
                                })
                    }
                    
                }.navigationBarTitle("Add New Schedule",displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action:{ changeScheduleViewPresented = false}, label: {
                        Text("Cancel")
                    }), trailing: Button(action:{
                        if habitModel.habits[inputHabitidpos].durationBased {
                            entryModel.entries[entryIndex].changeProp(inHabitid: habitModel.habits[inputHabitidpos].id, inScore: inputScore, inBeginTime: inputBeginTime, inEndTime: inputEndTime)
                            entryModel.refresh.toggle()
                            changeScheduleViewPresented = false
                        } else {
                            // If the habit is hit-based, the endtime is set to begin time
                            entryModel.entries[entryIndex].changeProp(inHabitid: habitModel.habits[inputHabitidpos].id, inScore: inputScore, inBeginTime: inputBeginTime, inEndTime: inputBeginTime)
                            habitModel.activeIdpos = inputHabitidpos
                            entryModel.refresh.toggle()
                            changeScheduleViewPresented = false
                        }
                    }, label: {
                        Text("Save")
                    }))
            }
        }.onAppear(){
            if let indexing = habitModel.idIndexing[entryModel.entries[entryIndex].habitid]{
                inputHabitidpos = indexing
            }
            inputScore = entryModel.entries[entryIndex].score
            inputBeginTime = entryModel.entries[entryIndex].beginTime
            inputEndTime = entryModel.entries[entryIndex].endTime
        }
    }
}

struct ChangeScheduleView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        ChangeScheduleView(changeScheduleViewPresented: $dummyBool, entryIndex: 1)
    }
}
