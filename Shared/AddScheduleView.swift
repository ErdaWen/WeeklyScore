//
//  AddEntryView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/7/21.
//

import SwiftUI

struct AddScheduleView: View {
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    
    @State var inputHabitidpos = 0
    @State var inputScore = 0
    @State var inputBeginTime = Date()
    @State var inputEndTime = Date()
    @State var showEndTimeWarning = false
    
    @Binding var addEntryViewPresented:Bool
    
    var body: some View {
        
        NavigationView(){
            // If habit list is not empty
            if inputHabitidpos != -1 {
                Form{
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
                    leading: Button(action:{ addEntryViewPresented = false}, label: {
                    Text("Cancel")
                }), trailing: Button(action:{
                    if habitModel.habits[inputHabitidpos].durationBased {
                        entryModel.addEntry(inHabitid: habitModel.habits[inputHabitidpos].id, inScore: inputScore, inBeginTime: inputBeginTime, inEndTime: inputEndTime, inHidden: false)
                        habitModel.activeIdpos = inputHabitidpos
                        addEntryViewPresented = false
                    } else {
                        // If the habit is hit-based, the endtime is set to begin time
                        // (so that when later on the habit change to duration-based, the hours are still kind of valid)
                        entryModel.addEntry(inHabitid: habitModel.habits[inputHabitidpos].id, inScore: inputScore, inBeginTime: inputBeginTime, inEndTime: inputBeginTime, inHidden: false)
                        habitModel.activeIdpos = inputHabitidpos
                        addEntryViewPresented = false
                    }
                                        }, label: {
                                            Text("Add")
                                        }))
            } else {
                // Habit list is empty
                Text("No habit, add habit first")
            }
            
        }.onAppear(){
            inputHabitidpos = habitModel.activeIdpos
            inputScore = habitModel.habits[inputHabitidpos].defaultScore
            inputBeginTime = entryModel.startOfThisWeek()
            inputEndTime = entryModel.startOfThisWeek() + 3600
        }
    }
}

struct AddEntryView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        AddScheduleView(addEntryViewPresented:$dummyBool)
    }
}
