//
//  ChangeCompletionView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/8/21.
//

import SwiftUI

struct ChangeCompletionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var changeCompletionViewPresented:Bool
    
    var schedule: Schedule
    @State var habitId = 0
    @State var orgScoreGained:Int64 = 0
    @State var orgMinutesGained:Int64 = 0
    @State var orgChecked = false
    @State var checkChanged:Int64 = 0
    @State var inputScoreGained:Int64 = 0
    @State var inputMinutesGained:Int64 = 0
    @State var inputMinutesGainedString = "0"
    @State var inputChecked = false
    
    
    @State var itemMinute:Int64 = 0
    // For duration-based habit, the status goes 3 ways
    // This var should be adjusted with the inputchecked at the same time
    // 0: messed up, 1: partial credit, 2: complete, 3: extra
    @State var completeState = 0
    // passivestateChange is false if the picker is jumped because of input hour is not as required
    @State var activeStateChange = true
    
    
    var body: some View {
        NavigationView{
            Form{
                if schedule.items.durationBased{
                    // MARK: Duration-based case
                    // MARK: Completion status piker
                    Picker("", selection:$completeState){
                        Text("Messed up").tag(0)
                        Text("Partial").tag(1)
                        Text("Compelete").tag(2)
                        Text("Plus").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    //update check status and scores with given picker
                    .onChange(of: completeState, perform: { value in
                        if completeState == 0
                        {
                            // No score, 0 score, 0 hour
                            inputChecked = false
                            inputScoreGained = 0
                            inputMinutesGained = 0
                            inputMinutesGainedString = String(inputMinutesGained)
                        }
                        else if (completeState == 1)
                        {
                            // Partial score, leave the values to be entered in the textfields.
                            inputChecked = true
                            if activeStateChange{
                                inputScoreGained = schedule.score
                                inputMinutesGained = itemMinute
                                inputMinutesGainedString = String(inputMinutesGained)
                            } else {
                                // Passive change to partial state, entered hours is more than full hours
                                inputScoreGained = schedule.score
                                // Reset activeStateChange
                                activeStateChange = true
                            }
                            
                        }
                        else if (completeState == 3)
                        {
                            // Extra, full socre, hours to be entered, default at full hours
                            inputChecked = true
                            if activeStateChange{
                                inputScoreGained = schedule.score
                                inputMinutesGained = itemMinute
                                inputMinutesGainedString = String(inputMinutesGained)
                            } else {
                                // Passive change to partial state, entered hours is less than full hours
                                inputScoreGained = schedule.score
                                // Reset activeStateChange
                                activeStateChange = true
                            }
                        }
                        else
                        {
                            inputChecked = true
                            inputScoreGained = schedule.score
                            inputMinutesGained = itemMinute
                            inputMinutesGainedString = String(inputMinutesGained)
                        }
                    })
                    
                    HStack{
                        //MARK: Score Picker
                        Stepper("Score: \(inputScoreGained)", value: $inputScoreGained, in: 0...schedule.score)
                            .disabled(completeState != 1)
                        //MARK: Input minute textfield
                        TextField("Minute", text: $inputMinutesGainedString)
                            // the input is a string
                            .keyboardType(.numberPad)
                            .disabled((completeState == 0)||(completeState == 2))
                            // update actual var here
                            .onChange(of: inputMinutesGainedString, perform: { value in
                                if let inputnumber = Double(inputMinutesGainedString) {
                                    // protect the number being Int
                                    inputMinutesGainedString = String(Int(inputnumber))
                                    inputMinutesGained = Int64(inputnumber)
                                }
                                // autoswitch the picker
                                if (inputMinutesGained > itemMinute)&&(completeState == 1)
                                {
                                    // If input hours is large than full hours in partial state, trigger passive state chagne
                                    activeStateChange = false
                                    //
                                    completeState = 3
                                }
                                else if (inputMinutesGained < itemMinute)&&(completeState == 3)
                                {
                                    // If input hours is less than full hours in partial state, trigger passive state chagne
                                    activeStateChange = false
                                    //
                                    completeState = 1
                                }
                            })
                    }
                    
                } else {
                    // MARK: Hit-based case
                    Picker("", selection:$inputChecked){
                        Text("Messed up").tag(false)
                        Text("Compelete").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: inputChecked, perform: { value in
                        if inputChecked{
                            inputScoreGained = schedule.score
                        } else {
                            inputScoreGained = 0
                        }
                    })
                    Text(" \(inputScoreGained) score Gained")
                }
                
            }
            .onAppear(){
                inputScoreGained = schedule.scoreGained
                inputMinutesGained = schedule.minutesGained
                inputMinutesGainedString = String(inputMinutesGained)
                inputChecked = schedule.checked
                orgScoreGained = inputScoreGained
                orgMinutesGained = inputMinutesGained
                orgChecked = inputChecked
                
                itemMinute=Int64((schedule.endTime.timeIntervalSinceReferenceDate - schedule.beginTime.timeIntervalSinceReferenceDate)/60)
                // Calculate the complete states
                if inputChecked {
                    if (inputMinutesGained == itemMinute) && (inputScoreGained == schedule.score) {
                        completeState = 2
                    } else if (inputMinutesGained > itemMinute){
                        completeState = 3
                    } else {
                        completeState = 1
                    }
                } else {
                    completeState = 0
                }
                
            }
            .navigationBarTitle("Record Scores",displayMode: .inline)
            .navigationBarItems(
                leading: Button(action:{
                    changeCompletionViewPresented = false
                }, label: {
                    Text("Cancel")
                })
                ,trailing: Button(action:{
                    // Execute change to entry
                    schedule.scoreGained = inputScoreGained
                    schedule.minutesGained = inputMinutesGained
                    schedule.checked = inputChecked
                    
                    // Calculate check changed
                    if orgChecked != inputChecked{
                        checkChanged = inputChecked ? 1 : -1
                    }
                    // Execute change to habit for records
                    schedule.items.checkedTotal += checkChanged
                    schedule.items.scoreTotal += inputScoreGained-orgScoreGained
                    schedule.items.minutesTotal += inputMinutesGained-orgMinutesGained
                    do{
                        try viewContext.save()
                        print("saved")
                        changeCompletionViewPresented = false
                    } catch {
                        print("Cannot save item")
                        print(error)
                    }
                    
                }, label: {
                    Text("Save")
                }))
        }

    }
}

//struct ChangeCompletionView_Previews: PreviewProvider {
//    @State static var dummyBool = true
//    static var previews: some View {
//        ChangeCompletionView(changeCompletionViewPresented: $dummyBool,entryIndex: 1)
//    }
//}
