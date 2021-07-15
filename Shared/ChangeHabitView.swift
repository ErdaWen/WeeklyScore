//
//  ChangeHabitView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/11/21.
//

import SwiftUI

struct ChangeHabitView: View {
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    @Binding var changeHabitViewPresented:Bool
    
    @State var inputTitleIcon = ""
    @State var inputTitle = ""
    @State var inputDefaultScore = 10
    @State var inputColorTag = 0
    
    
    var body: some View {
        NavigationView(){
            // habitIndex may overflow when deleting the last element, need to check
            if habitModel.habitIndex < habitModel.habits.count {
                Form{
                    // MARK:Title and color (HStack)
                    HStack(){
                        TextField("🏁",text:$inputTitleIcon).frame(width:35)
                        Divider()
                        TextField("Title",text:$inputTitle)
                        Divider()
                        Picker("",selection:$inputColorTag){
                            Rectangle().frame(width: 40, height: 40).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).cornerRadius(8.0).tag(0)
                            Rectangle().frame(width: 40, height: 40).foregroundColor(.green).tag(1)
                        }.frame(width: 50)
                    }
                    // MARK:Score (Stepper)
                    Stepper("Default Score: \(inputDefaultScore)", value: $inputDefaultScore, in: 0...20)
                    // MARK: Change duration-based
                    if habitModel.habits[habitModel.habitIndex].durationBased {
                        Button("Change to time-based") {
                            habitModel.habits[habitModel.habitIndex].changeDurationBased()
                        }
                    } else {
                        Button("Change to duration-based") {
                            habitModel.habits[habitModel.habitIndex].changeDurationBased()
                            habitModel.refresh.toggle()
                            changeHabitViewPresented = false
                        }
                    }
                    
                    Button("Archive Habits") {
                        changeHabitViewPresented = false
                        habitModel.habits[habitModel.habitIndex].archive()
                        habitModel.refresh.toggle()
                    }
                    
                    Button("Delete Habits") {
                        changeHabitViewPresented = false
                        entryModel.deleteAllEntryRelated(deletedHabitId: habitModel.habits[habitModel.habitIndex].id)
                        entryModel.refresh.toggle()
                        habitModel.deleteHabit(indexing:habitModel.habitIndex)
                    }
                    
                    // MARK: View title and button
                }.navigationBarTitle("Add New Habit",displayMode: .inline).navigationBarItems(leading: Button(action:{ changeHabitViewPresented = false}, label: {
                    Text("Cancel")
                }), trailing: Button(action:{
                    changeHabitViewPresented = false
                    habitModel.habits[habitModel.habitIndex].changeProp(inTitleIcon: inputTitleIcon, inTitle: inputTitle, inDefaultScore: inputDefaultScore, inColorTag: inputColorTag)
                    habitModel.refresh.toggle()
                }, label: {
                    Text("Save")
                }))
            }
        }.onAppear(){
            inputTitleIcon = habitModel.habits[habitModel.habitIndex].titleIcon
            inputTitle = habitModel.habits[habitModel.habitIndex].title
            inputDefaultScore = habitModel.habits[habitModel.habitIndex].defaultScore
            inputColorTag = habitModel.habits[habitModel.habitIndex].colorTag
        }
    }
}

struct ChangeHabitView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        ChangeHabitView(changeHabitViewPresented: $dummyBool)
            .environmentObject(EntryModel())
            .environmentObject(HabitModel())
    }
}
