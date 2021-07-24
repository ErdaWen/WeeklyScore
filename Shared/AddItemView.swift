//
//  AddItemView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI
import UIKit

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var inputDurationBased = true
    @State var inputTitleIcon = "☑️"
    @State var inputTitle = ""
    @State var inputDefaultScore:Int64 = 10
    @State var inputDefaultMinutes:Int64 = 60
    @State var inputDefaultMinutesString = "60"
    @State var inputColorTag:Int64 = 0
    
    @Binding var addItemViewPresented:Bool
    
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
                // MARK:Default score (Stepper)
                Stepper("Default Score: \(inputDefaultScore)", value: $inputDefaultScore, in: 0...20)
                // MARK: Default hours (Textfield)
                
                if inputDurationBased {
                TextField("Minute", text: $inputDefaultMinutesString)
                    // the input is a string
                    .keyboardType(.numberPad)
                    // update actual var here
                    .onChange(of: inputDefaultMinutesString, perform: { value in
                        if let inputnumber = Double(inputDefaultMinutesString) {
                            // protect the number being Int
                            inputDefaultMinutesString = String(Int(inputnumber))
                            inputDefaultMinutes = Int64(inputnumber)
                        }
                    })
                }
                
                // MARK: View title and button
            }.navigationBarTitle("Add New Habit",displayMode: .inline)
            .navigationBarItems (leading: Button(action:{ addItemViewPresented = false}, label: {
                Text("Cancel")
            }), trailing: Button(action:{
                let newItem = Item(context: viewContext)
                newItem.id = UUID()
                newItem.hidden = false
                newItem.titleIcon = inputTitleIcon
                newItem.title = inputTitle
                newItem.durationBased = inputDurationBased
                newItem.colorTag = inputColorTag
                newItem.defaultMinutes = inputDurationBased ? inputDefaultMinutes : 0
                newItem.defaultScore = inputDefaultScore
                newItem.checkedTotal = 0
                newItem.minutesTotal = 0
                newItem.scoreTotal = 0
                newItem.lastUse = Date()
                do{
                    try viewContext.save()
                    print("saved")
                    addItemViewPresented = false
                } catch {
                    print("Cannot save item")
                    print(error)
                }
                
            }, label: {Text("Add")})
            )
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        AddItemView(addItemViewPresented: $dummyBool)
    }
}
