//
//  ChangeHabitView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/11/21.
//

import SwiftUI

struct ChangeItemView: View {
    
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    @Binding var changeItemViewPresented:Bool
    
    var item: Item
    
    @State var inputTitleIcon = ""
    @State var inputTitle = ""
//    @State var inputDefaultScore:Int64 = 10

    @State var inputDurationBased = false
    @State var tagid = 0
    
    
    @State var activeAlert:ActiveAlert = .conflict
    @State var showConflictAlert = false
    @State var showBaseAlert = false
    @State var showDeleteAlert = false
    
    let mNavBar:CGFloat = 25
    let fsNavBar:CGFloat = 20
    let mVer:CGFloat = 22
    let mHor:CGFloat = 10
    let hField:CGFloat = 45
    
    
    enum ActiveAlert {
        case noIcon, conflict
    }
        
    func saveItem(){
        changeItemViewPresented = false
        item.titleIcon = inputTitleIcon
        item.title = inputTitle

        item.durationBased = inputDurationBased
        item.tags = tags[tagid]
        tags[tagid].lastUse = Date()
        
        // Save
        do{
            try viewContext.save()
            propertiesModel.dumUpdate.toggle()
            print("saved")
            changeItemViewPresented = false
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
                if (results.count == 1) && (results[0].id == item.id) {
                    // Cannot conflict with itself
                    conflict = false
                }
            } catch {
                print(error)
            }
        }
        return conflict
    }
    
    func deleteItem() {
        changeItemViewPresented = false
        viewContext.delete(item)
        do{
            try viewContext.save()
            print("deleted")
            changeItemViewPresented = false
        } catch {
            print("Cannot delete item")
            print(error)
        }
    }
    
    var body: some View {
        VStack{
            //MARK: Navigation Bar
            HStack{
                //MARK: Cancel button
                Button(action:{ changeItemViewPresented = false}
                       , label: {
                        Text("Cancel")
                            .foregroundColor(Color("text_red")).font(.system(size: fsNavBar))
                       })
                
                Spacer()
                //MARK: Title
                Text("Edit Habit")
                    .font(.system(size: fsNavBar))
                Spacer()
                
                //MARK: Save button
                Button(action:{
                    if checkItemConflict() {
                        showConflictAlert = true
                    } else {
                        saveItem()
                    }
                }, label: {
                    Text("  Save")
                        .foregroundColor((inputTitle.isEmpty || inputTitleIcon.isEmpty) ? Color("text_black").opacity(0.5) : Color("text_blue"))
                        .font(.system(size: fsNavBar)).fontWeight(.semibold)

                })
                .disabled(inputTitle.isEmpty || inputTitleIcon.isEmpty)
                .alert(isPresented: $showConflictAlert) {
                    switch activeAlert{
                    case .noIcon:
                        return Alert(title: Text("❌ No Icon"), message: Text("Select an Icon...") , dismissButton:.default(Text("OK"), action: {
                            showConflictAlert = false
                        }))
                    case .conflict:
                        return Alert(title: Text("❌ Conflict"), message: Text("There is already a habit with a same title"), dismissButton:.default(Text("OK"), action: {
                            showConflictAlert = false
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
                    
                    if !item.hidden{
                        
                        // MARK:Habit Type: Duration/time-based (Segmented picker)
                        // MARK: warning to be added
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
                                    showBaseAlert = true
                                } label: {
                                    Text("Duration")
                                        .font(.system(size:15))
                                        .fontWeight(.light)
                                        .foregroundColor(Color("text_black"))
                                        .frame(width: 150, alignment: .center)
                                }
                                Button(action: {
                                    showBaseAlert = true
                                }, label: {
                                    Text("Hit")
                                        .font(.system(size:15))
                                        .fontWeight(.light)
                                        .foregroundColor(Color("text_black"))
                                        .frame(width: 150, alignment: .center)
                                })
                            }
                        }.frame(width: 300, height: 40,alignment: .center)
                        .alert(isPresented: $showBaseAlert) {
                            if inputDurationBased {
                                return Alert(title: Text(" ⚠️ Change type"), message: Text("Changing to hit-based will change the static method from total time to total hit, total time will be no longer shown...") , primaryButton:.default(Text("Do not change"), action: {
                                    showBaseAlert = false
                                }),secondaryButton: .default(Text("Change"), action: {inputDurationBased.toggle()} ))
                            } else {
                                return Alert(title: Text(" ⚠️ Change type"), message: Text("Changing to duration-based will change the static method from total hit to total time, previous checked items count for no time...") , primaryButton:.default(Text("Do not change"), action: {
                                    showBaseAlert = false
                                }),secondaryButton: .default(Text("Change"), action: {inputDurationBased.toggle()} ))
                            }// end if else swith
                        }// end alert
                        
 
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
                            }.pickerStyle(WheelPickerStyle())
                        })
                        
                    } // end if !hidden
                    
                    Button {
                        item.hidden.toggle()
                        do{
                            try viewContext.save()
                            print("saved")
                            changeItemViewPresented = false
                        } catch {
                            print("Cannot save item")
                            print(error)
                        }
                    } label: {
                        HStack{
                            Image(systemName: "archivebox")
                                .resizable().scaledToFit()
                                .foregroundColor(Color("text_blue")).frame(height:20)
                            Text("Delete Habit...")
                                .foregroundColor(Color("text_blue"))
                                .font(.system(size: 20))
                        }

                    }
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        HStack{
                            Image(systemName: "trash")
                                .resizable().scaledToFit()
                                .foregroundColor(Color("text_red")).frame(height:20)
                            Text("Delete Habit...")
                                .foregroundColor(Color("text_red"))
                                .font(.system(size: 20))
                        }
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(title: Text("🤔 You Sure?"), message: Text("All Schedules will also be deleted! If you are done with this habit, simply archive it and it won't show"), primaryButton: .default(Text("Keep"), action: {
                            showDeleteAlert = false
                        }), secondaryButton: .default(Text("Delete").foregroundColor(Color("text_red")), action: {
                            deleteItem()
                            changeItemViewPresented = false
                        }))
                    }
                    .foregroundColor(Color("text_red"))
                    .font(.system(size: 20))
                    
                    Spacer()
                }.padding(.init(top: 0, leading: 20, bottom: 10, trailing: 20))
            }
        }
        .onAppear(){
            tagid = tags.firstIndex(where: {$0.id == item.tags.id}) ?? 0
            inputTitleIcon = item.titleIcon
            inputTitle = item.title
            inputDurationBased = item.durationBased
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
