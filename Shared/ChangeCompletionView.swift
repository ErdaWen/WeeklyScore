//
//  ChangeCompletionView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/8/21.
//

import SwiftUI

struct ChangeCompletionView: View {
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    @Binding var changeCompletionViewPresented:Bool
    
    var entryIndex: Int
    @State var habitIndex = 0
    @State var orgScoreGained = 0
    @State var orgHoursGained = 0.0
    @State var orgChecked = false
    @State var inputScoreGained = 0
    @State var inputHoursGained = 0.0
    @State var inputChecked = false
    
    @State var habitHours = 0.0
    // For duration-based habit, the status goes 3 ways
    // This var should be adjusted with the inputchecked at the same time
    // 0: messed up, 1: partial credit/manual, 2: complete
    @State var completeState = 0
    
    
    var body: some View {
        NavigationView{
            Form{
                if habitModel.habits[habitIndex].durationBased{
                    // MARK:Duration-based case
                    Picker("", selection:$completeState){
                        Text("Messed up").tag(0)
                        Text("Manual").tag(1)
                        Text("Compelete").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: completeState, perform: { value in
                        if completeState == 0 {
                            inputChecked = false
                            inputScoreGained = 0
                            inputHoursGained = 0.0
                        } else if (completeState == 1){
                            inputChecked = true
                        } else {
                            inputChecked = true
                            inputScoreGained = entryModel.entries[entryIndex].score
                            inputHoursGained = habitHours
                        }
                    })
                    if completeState == 2 {
                        Text ("Full credit, score = \(inputScoreGained), hoursgained = \(inputHoursGained)")
                    } else if (completeState == 1){
                        
                    }
                    
                } else {
                    // MARK: Hit-based case
                }
                
            }
        }.onAppear(){
            // Get habit index
            if let indexing = habitModel.idIndexing[entryModel.entries[entryIndex].habitid]{
                habitIndex = indexing
            }
            inputScoreGained = entryModel.entries[entryIndex].scoreGained
            inputHoursGained = entryModel.entries[entryIndex].hoursGained
            inputChecked = entryModel.entries[entryIndex].checked
            orgScoreGained = inputScoreGained
            orgHoursGained = inputHoursGained
            
            habitHours=(entryModel.entries[entryIndex].endTime.timeIntervalSinceReferenceDate - entryModel.entries[entryIndex].beginTime.timeIntervalSinceReferenceDate)/3600
            // Calculate the complete states
            if inputChecked {
                if (inputHoursGained == habitHours) && (inputScoreGained == entryModel.entries[entryIndex].score) {
                    completeState = 2
                } else {
                    completeState = 1
                }
                
            } else {
                completeState = 0
            }
            
        }
    }
}

struct ChangeCompletionView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        ChangeCompletionView(changeCompletionViewPresented: $dummyBool,entryIndex: 0)
    }
}
