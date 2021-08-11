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
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    @State var inputDurationBased = true
    @State var inputTitleIcon = ""
    @State var inputTitle = ""
    @State var tagid = 0
    
    @State var activeAlert:ActiveAlert = .conflict
    @State var showAlert = false
    
    let mNavBar:CGFloat = 25
    let fsNavBar:CGFloat = 20
    let mVer:CGFloat = 22
    let mHor:CGFloat = 10
    let hField:CGFloat = 45
    
    @Binding var addItemViewPresented:Bool
    
    
    enum ActiveAlert {
        case noIcon, conflict
    }
    
    func saveItem(){
        let newItem = Item(context: viewContext)
        newItem.id = UUID()
        newItem.hidden = false
        newItem.titleIcon = inputTitleIcon
        newItem.title = inputTitle
        newItem.durationBased = inputDurationBased
        newItem.defaultMinutes = inputDurationBased ? 60 : 0
        newItem.defaultScore = 10
        newItem.defaultBeginTime = DateServer.startOfToday() + 28800
        newItem.defaultReminder = false
        newItem.defaultReminderTime = 0
        newItem.checkedTotal = 0
        newItem.minutesTotal = 0
        newItem.scoreTotal = 0
        newItem.lastUse = Date()
        newItem.tags = tags[tagid]
        tags[tagid].lastUse = Date()
        do{
            try viewContext.save()
            print("saved")
            addItemViewPresented = false
        } catch {
            print("Cannot save item")
            print(error)
        }
    }
    
    func checkItemConflict() -> Bool {
        var conflict = false
        if inputTitleIcon == "" {
            activeAlert = .noIcon
            conflict = true
        } else {
            let request = Item.itemFetchRequest()
            request.predicate = NSPredicate(format: "(title == %@)", inputTitle)
            do {
                let results = try viewContext.fetch(request)
                if results.count > 0 {
                    activeAlert = .conflict
                    conflict = true
                }
            } catch {
                print(error)
            }
        }
        return conflict
    }
    
    var body: some View {
        VStack{
            //MARK: Navigation Bar
            HStack{
                Button(action:{ addItemViewPresented = false}
                       , label: {
                        Text("Discard").foregroundColor(Color("text_red")).font(.system(size: fsNavBar))
                       })
                Spacer()
                Text("New Habit")
                    .font(.system(size: fsNavBar))
                
                Spacer()
                Button(action:{
                    if checkItemConflict() {
                        showAlert = true
                    } else {
                        saveItem()
                    }
                }, label: {
                    Text("   Add").foregroundColor(Color("text_blue")).font(.system(size: fsNavBar)).fontWeight(.semibold)
                    
                })
                .alert(isPresented: $showAlert) {
                    switch activeAlert{
                    case .noIcon:
                        return Alert(title: Text("❌ No Icon"), message: Text("Select an Icon...") , dismissButton:.default(Text("OK"), action: {
                            showAlert = false
                        }))
                    case .conflict:
                        return Alert(title: Text("❌ Conflict"), message: Text("There is already a habit with a same title"), dismissButton:.default(Text("OK"), action: {
                            showAlert = false
                        }))
                    }// end switch
                }// end alert
            }.padding(mNavBar)
            
            ScrollView{
                VStack(spacing:mVer){
                    HStack(spacing:mHor){
                        //MARK: Icon
                        InputField(title: "Icon", alignment: .center, color: Color(tags[tagid].colorName), fieldHeight: hField, content: {
                            EmojiTextField(text: $inputTitleIcon, placeholder: "")
                                .font(.system(size: 50))
                                .foregroundColor(Color("text_black"))
                                .frame(width:20,height: 20)
                                .padding(12.5)
                                .onChange(of: inputTitleIcon, perform: { value in
                                    if let lastChar = inputTitleIcon.last{
                                        inputTitleIcon = String(lastChar)
                                    }
                                    if inputTitleIcon.isEmpty{
                                        inputTitleIcon = "❓"
                                    }
                                })
                        })
                        .frame(width:hField)
                        
                        // MARK:Title
                        InputField(title: "Title", alignment: .leading, color: Color(tags[tagid].colorName), fieldHeight: hField) {
                            TextField("New Habit",text:$inputTitle)
                                .font(.system(size: 20))
                                .foregroundColor(Color("text_black"))
                                .padding(.init(top: 3, leading: 5, bottom: 3, trailing: 5))
                        }
                    }.animation(.default)
                    
                    
                    // MARK:Habit Type: Duration/time-based picker
                    ZStack(){
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color("background_grey"))
                        HStack{
                            if !inputDurationBased {Spacer()}
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color(tags[tagid].colorName)).opacity(0.3)
                                .frame(width: 150, height: 30)
                                .padding(.leading, 5)
                                .padding(.trailing, 5)
                            if inputDurationBased {Spacer()}
                        }.animation(.default)
                        HStack(){
                            Button {
                                inputDurationBased = true
                            } label: {
                                Text("Duration")
                                    .font(.system(size:15))
                                    .fontWeight(.light)
                                    .foregroundColor(Color("text_black"))
                                    .frame(width: 150, alignment: .center)
                            }
                            Button(action: {
                                inputDurationBased = false
                            }, label: {
                                Text("Hit")
                                    .font(.system(size:15))
                                    .fontWeight(.light)
                                    .foregroundColor(Color("text_black"))
                                    .frame(width: 150, alignment: .center)
                            })
                        }
                    }.frame(width: 300, height: 40,alignment: .center)
                    
                    
                    //                    HStack(spacing:10){
                    //                        // MARK: Default score
                    //                        VStack(alignment: .leading, spacing: 8.0){
                    //                            Text("Default score")
                    //                                .font(.system(size: 15))
                    //                                .foregroundColor(Color("text_black"))
                    //                                .fontWeight(.light)
                    //                            ZStack(alignment: .center){
                    //                                RoundedRectangle(cornerRadius: 8.0)
                    //                                    .stroke(Color(tags[tagid].colorName),style:StrokeStyle(lineWidth: 1.5))
                    //                                HStack{
                    //                                    Text("\(inputDefaultScore)")
                    //                                        .font(.system(size: 20))
                    //                                        .foregroundColor(Color("text_black"))
                    //                                    Spacer()
                    //                                    Stepper("", value: $inputDefaultScore, in: 0...20)
                    //                                        .frame(width:100,height: 50)
                    //                                }
                    //                                .padding(.leading,10)
                    //                                .padding(.trailing,10)
                    //                            }
                    //                        }
                    //
                    //                        // MARK:Default minutes
                    //                        if inputDurationBased{
                    //                            VStack(alignment: .leading, spacing: 7.0){
                    //                                Text("Default minuite")
                    //                                    .font(.system(size: 15))
                    //                                    .foregroundColor(Color("text_black"))
                    //                                    .fontWeight(.light)
                    //                                ZStack(alignment: .center){
                    //                                    RoundedRectangle(cornerRadius: 8.0)
                    //                                        .stroke(Color(tags[tagid].colorName),style:StrokeStyle(lineWidth: 1.5))
                    //                                    TextField("Minute", text: $inputDefaultMinutesString)
                    //                                        // the input is a string
                    //                                        .keyboardType(.numberPad)
                    //                                        // update actual var here
                    //                                        .onChange(of: inputDefaultMinutesString, perform: { value in
                    //                                            if let inputnumber = Double(inputDefaultMinutesString) {
                    //                                                // protect the number being Int
                    //                                                inputDefaultMinutesString = String(Int(inputnumber))
                    //                                                inputDefaultMinutes = Int64(inputnumber)
                    //                                            } else {
                    //                                                inputDefaultMinutesString = "0"
                    //                                                inputDefaultMinutes = 0
                    //                                            }
                    //                                        })
                    //                                        .font(.system(size: 20))
                    //                                        .foregroundColor(Color("text_black"))
                    //                                        .padding(.init(top: 3, leading: 5, bottom: 3, trailing: 5))
                    //                                }
                    //                                .frame(height: 50)
                    //                            }
                    //                        }
                    //                    }//End Default settings
                    //                    .animation(.default)
                    
                    //MARK: Tags
                    InputField(title: "Choose a tag", alignment: .leading, color: Color(tags[tagid].colorName), fieldHeight:nil, content: {
                        Picker("",selection:$tagid){
                            ForEach(0...tags.count-1, id:\.self) { r in
                                HStack(spacing:10.0){
                                    Rectangle().frame(width: 20, height: 20).foregroundColor(Color(tags[r].colorName)).cornerRadius(8.0)
                                    Text(tags[r].name)
                                        .font(.system(size: 20))
                                        .fontWeight(.light)
                                        .foregroundColor(Color("text_black"))
                                }.tag(r)
                            }
                        }
                    })
                    
                    Spacer()
                }.padding(.init(top: 0, leading: 20, bottom: 10, trailing: 20))
            }
        }
        //}
    }
}

struct AddHabitView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        AddItemView(addItemViewPresented: $dummyBool)
    }
}
