//
//  AddHabitView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI
import UIKit

struct AddHabitView: View {
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    
    @State var inputDurationBased = true
    @State var inputTitleIcon = "☑️"
    @State var inputTitle = ""
    @State var inputDefaultScore = 10
    @State var inputColorTag = 0
    @State var hidden = false
    
    @Binding var addHabitViewPresented:Bool
    
    var body: some View {
        NavigationView(){
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
                    //TextField("🏁",text:$inputTitleIcon).frame(width:35)
                    Divider()
                    TextField("Title",text:$inputTitle)
                    Divider()
                    Picker("",selection:$inputColorTag){
                        Rectangle().frame(width: 40, height: 40).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).cornerRadius(8.0).tag(0)
                        Rectangle().frame(width: 40, height: 40).foregroundColor(.green).tag(1)
                    }.frame(width: 50)
                }
                // MARK:Habit Type: Duration/time-based (Segmented picker)
                Picker("", selection:$inputDurationBased){
                    Text("Duration").tag(true)
                    Text("Time-based").tag(false)
                }.pickerStyle(SegmentedPickerStyle()).frame(width: 250)
                // MARK:Score (Stepper)
                Stepper("Default Score: \(inputDefaultScore)", value: $inputDefaultScore, in: 0...20)
                // MARK: View title and button
            }.navigationBarTitle("Add New Habit",displayMode: .inline).navigationBarItems(leading: Button(action:{ addHabitViewPresented = false}, label: {
                Text("Cancel")
            }), trailing: Button(action:{
                                    habitModel.addHabit(inDurationbased: inputDurationBased, inTitleIcon: inputTitleIcon, inTitle: inputTitle, inDefaultScore: inputDefaultScore, inColorTag: inputColorTag, inHidden: false)
                                    addHabitViewPresented = false}, label: {
                                        Text("Add")
                                    }))
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        AddHabitView(addHabitViewPresented: $dummyBool)
    }
}
