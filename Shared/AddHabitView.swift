//
//  AddHabitView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI

struct AddHabitView: View {
    @ObservedObject var habitModel = HabitModel()
    @ObservedObject var entryModel = EntryModel()
    
    @State var inputDurationBased = true
    @State var inputTitleIcon = ""
    @State var inputTitle = ""
    @State var inputDefaultScore = 10
    @State var inputColorTag = 0
    @State var hidden = false
    
    var body: some View {
            Form{
                HStack(){
                    TextField("Icon",text:$inputTitleIcon).frame(width:35)
                    Divider()
                    TextField("Title",text:$inputTitle)
                    Divider()
                    Picker(" Tag",selection:$inputColorTag){
                        Rectangle().frame(width: 40, height: 40).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).cornerRadius(8.0).tag(0)
                        Rectangle().frame(width: 40, height: 40).foregroundColor(.green).tag(1)
                    }.frame(width: 110)
                }
                
                Picker("", selection:$inputDurationBased){
                    Text("Duration").tag(true)
                    Text("Time-based").tag(false)
                }.pickerStyle(SegmentedPickerStyle()).frame(width: 250)
                //TextField("Score", text: $inputDefaultScoreString)
                 //   .keyboardType(.numberPad)
                Stepper("Default Score: \(inputDefaultScore)", value: $inputDefaultScore, in: 1...100)
                //Stepper(value: $inputDefaultScoreString, in: 1...100, label: Text("Default Score: \(inputDefaultScore)"))
            }.navigationBarTitle("Profile")
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
    }
}
