//
//  AddEntryView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/7/21.
//

import SwiftUI

struct AddEntryView: View {
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    
    @State var inputHabitid:Int
    @State var inputScore = 0
    @State var inputBeginTime = Date()
    @State var inputEndTime = Date()
    
    @Binding var addEntryViewPresented:Bool
    
    var body: some View {
        
        NavigationView(){
            Form{
                HStack(){
                    Picker("Habbit",selection:$inputHabitid){
                        
                    }
                    
                    Divider()
                    Divider()

                }

                Stepper("Score: \(inputScore)", value: $inputScore, in: 1...100)
            }.navigationBarTitle("Add New Schedule",displayMode: .inline).navigationBarItems(leading: Button(action:{ addEntryViewPresented = false}, label: {
                Text("Cancel")
            }), trailing: Button(action:{
                                    entryModel.addEntry(inHabitid: inputHabitid, inScore: inputScore, inBeginTime: inputBeginTime, inEndTime: inputEndTime, inHidden: false)
                                    addEntryViewPresented = false}, label: {
                                        Text("Add")
                                    }))
        }
    }
}

struct AddEntryView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        AddEntryView(inputHabitid:1,addEntryViewPresented:$dummyBool)
    }
}
