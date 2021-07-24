//
//  ChangeHabitView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/11/21.
//

import SwiftUI

struct ChangeItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    @Binding var changeItemViewPresented:Bool
    
    var item: Item
    
    @State var inputTitleIcon = ""
    @State var inputTitle = ""
    @State var inputDefaultScore:Int64 = 10
    @State var inputDefaultMinutes:Int64 = 0
    @State var inputDefaultMinutesString = "0"
    @State var tagid = 0 
    
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
                        Divider()
                        TextField("Title",text:$inputTitle)
                        Divider()
                        Picker("",selection:$tagid){
                            ForEach(0...tags.count-1, id:\.self) { r in
                                Rectangle().frame(width: 40, height: 40).foregroundColor(Color(tags[r].colorName)).cornerRadius(8.0).tag(r)
                            }
                        }.frame(width: 50)
                    }
                    // MARK:Score (Stepper)
                    Stepper("Default Score: \(inputDefaultScore)", value: $inputDefaultScore, in: 0...20)
                    // MARK: Change default minuites:
                    if item.durationBased {
                    TextField("Minute", text: $inputDefaultMinutesString)
                        // the input is a string
                        .keyboardType(.numberPad)
                        // update actual var here
                        .onChange(of: inputDefaultMinutesString, perform: { value in
                            if let inputnumber = Double(inputDefaultMinutesString) {
                                // protect the number being Int
                                inputDefaultMinutesString = String(Int(inputnumber))
                                inputDefaultMinutes = Int64(inputnumber)
                            } else {
                                inputDefaultMinutesString = "0"
                                inputDefaultMinutes = 0
                            }
                        })
                    }
                    // MARK: Change duration-based
                    if item.durationBased {
                        Button("Change to time-based") {
                            item.durationBased = false
                        }
                    } else {
                        Button("Change to duration-based") {
                            item.durationBased = true
                        }
                    }
                    
                    Button("Archive Habits") {
                        changeItemViewPresented = false
                        item.hidden = true
                    }
                    
                    Button("Delete Habits") {
                        changeItemViewPresented = false
                        viewContext.delete(item)
                    }
                    
                    // MARK: View title and button
                }.navigationBarTitle("Add New Habit",displayMode: .inline).navigationBarItems(leading: Button(action:{ changeItemViewPresented = false}, label: {
                    Text("Cancel")
                }), trailing: Button(action:{
                    changeItemViewPresented = false
                    item.titleIcon = inputTitleIcon
                    item.title = inputTitle
                    item.defaultScore = inputDefaultScore
                    item.defaultMinutes = inputDefaultMinutes
                    item.tags = tags[tagid]

                }, label: {
                    Text("Save")
                }))
            
        }.onAppear(){
            tagid = tags.firstIndex(where: {$0.id == item.tags.id}) ?? 0
            inputTitleIcon = item.titleIcon
            inputTitle = item.title
            inputDefaultScore = item.defaultScore
            inputDefaultMinutes = item.defaultMinutes
        }
    }
}

//struct ChangeHabitView_Previews: PreviewProvider {
//    @State static var dummyBool = true
//    static var previews: some View {
//        ChangeItemView(changeItemViewPresented: $dummyBool, habitIndex: 1)
//            .environmentObject(EntryModel())
//            .environmentObject(HabitModel())
//    }
//}
