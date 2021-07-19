//
//  ChangeHabitView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/11/21.
//

import SwiftUI

struct ChangeItemView: View {
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    @Binding var changeHabitViewPresented:Bool
    
    var habitIndex: Int
    
    @State var inputTitleIcon = ""
    @State var inputTitle = ""
    @State var inputDefaultScore = 10
    @State var inputColorTag = 0
    
    
    var body: some View {
        NavigationView(){
            // habitIndex may overflow when deleting the last element, need to check
            if habitIndex < habitModel.habits.count {
                Form{
                    // MARK:Title and color (HStack)
                    HStack(){
                        EmojiTextField(text: $inputTitleIcon, placeholder: "").onChange(of: inputTitleIcon, perform: { value in
                            if let lastChar = inputTitleIcon.last{
                                inputTitleIcon = String(lastChar)
                            }
                            if inputTitleIcon.isEmpty{
                                inputTitleIcon = "❓"
                            }
                        }).frame(width:35)
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
                    if habitModel.habits[habitIndex].durationBased {
                        Button("Change to time-based") {
                            habitModel.habits[habitIndex].changeDurationBased()
                        }
                    } else {
                        Button("Change to duration-based") {
                            habitModel.habits[habitIndex].changeDurationBased()
                            habitModel.updateChange()
                            changeHabitViewPresented = false
                        }
                    }
                    
                    Button("Archive Habits") {
                        changeHabitViewPresented = false
                        habitModel.habits[habitIndex].archive()
                        habitModel.updateChange()
                    }
                    
                    Button("Delete Habits") {
                        changeHabitViewPresented = false
                        entryModel.deleteAllEntryRelated(deletedHabitId: habitModel.habits[habitIndex].id)
                        entryModel.refresh.toggle()
                        habitModel.deleteHabit(indexing:habitIndex)
                    }
                    
                    // MARK: View title and button
                }.navigationBarTitle("Add New Habit",displayMode: .inline).navigationBarItems(leading: Button(action:{ changeHabitViewPresented = false}, label: {
                    Text("Cancel")
                }), trailing: Button(action:{
                    changeHabitViewPresented = false
                    habitModel.habits[habitIndex].changeProp(inTitleIcon: inputTitleIcon, inTitle: inputTitle, inDefaultScore: inputDefaultScore, inColorTag: inputColorTag)
                    habitModel.updateChange()
                }, label: {
                    Text("Save")
                }))
            }
        }.onAppear(){
            inputTitleIcon = habitModel.habits[habitIndex].titleIcon
            inputTitle = habitModel.habits[habitIndex].title
            inputDefaultScore = habitModel.habits[habitIndex].defaultScore
            inputColorTag = habitModel.habits[habitIndex].colorTag
        }
    }
}

struct ChangeHabitView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        ChangeItemView(changeHabitViewPresented: $dummyBool, habitIndex: 1)
            .environmentObject(EntryModel())
            .environmentObject(HabitModel())
    }
}
