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
    
    @State var inputHabitidpos = 0
    @State var inputScore = 0
    @State var inputBeginTime = Date()
    @State var inputEndTime = Date()
    
    @Binding var addEntryViewPresented:Bool
    
    var body: some View {
        
        NavigationView(){
            if inputHabitidpos != -1 {
                Form{
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
                    
                    Text("\(inputHabitidpos)")
                    Text("\(habitModel.habits[inputHabitidpos].id)")
                    Text("\(inputScore)")
                    
                }.navigationBarTitle("Add New Schedule",displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action:{ addEntryViewPresented = false}, label: {
                    Text("Cancel")
                }), trailing: Button(action:{
                                        entryModel.addEntry(inHabitid: habitModel.habits[inputHabitidpos].id, inScore: inputScore, inBeginTime: inputBeginTime, inEndTime: inputEndTime, inHidden: false)
                                        habitModel.activeIdpos = inputHabitidpos
                                        addEntryViewPresented = false}, label: {
                                            Text("Add")
                                        }))
            } else {
                Text("No habit, add habit first")
            }
            
        }.onAppear(){
            inputHabitidpos = habitModel.activeIdpos
            inputScore = habitModel.habits[inputHabitidpos].defaultScore
        }
    }
}

struct AddEntryView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        AddEntryView(addEntryViewPresented:$dummyBool)
    }
}
