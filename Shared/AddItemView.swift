//
//  AddItemView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI
import UIKit


struct AddItemView: View {
    @AppStorage("nightMode") private var nightMode = true

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
    @State var tagViewPresented = false
    
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
    
    func genNewTag(){
        let newTag = Tag(context: viewContext)
        newTag.id = UUID()
        newTag.name = "Unamed Catagory"
        newTag.colorName = "tag_color_red"
        do{
            try viewContext.save()
            print("New tag generated")
        } catch {
            print("Cannot generate new tag")
            print(error)
        }
    }
    
    var body: some View {
        VStack{
            if tags.count>0{
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
                        Text("   Add").foregroundColor((inputTitle.isEmpty || inputTitleIcon.isEmpty) ? Color("text_black").opacity(0.5) : Color("text_blue"))
                            .font(.system(size: fsNavBar)).fontWeight(.semibold)
                        
                    })
                    .disabled(inputTitle.isEmpty || inputTitleIcon.isEmpty)
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
                        
                        //MARK: Tags
                        InputField(title: "Choose a catogory", alignment: .leading, color: Color(tags[tagid].colorName), fieldHeight:nil, content: {
                            
                            ZStack(alignment:.bottomTrailing){
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
                                
                                FloatButton(systemName: "rectangle.and.pencil.and.ellipsis", sButton: 30) {
                                    tagViewPresented = true
                                }
                                .padding(.trailing, 10)
                                .padding(.bottom, 10)
                                .sheet(isPresented: $tagViewPresented) {
                                    EditTagView(editTagViewPresented: $tagViewPresented)
                                        .environment(\.managedObjectContext,self.viewContext)
                                }
                            }// end choose tag Zstack
                        })
                        
                        Spacer()
                    }.padding(.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                }
            }// end if
            
            
        } // end everything VStack
        .onAppear(){
            if tags.count == 0{
                genNewTag()
            }
        }
        .preferredColorScheme(nightMode ? nil : .light)

        //}
    }
}

struct AddHabitView_Previews: PreviewProvider {
    @State static var dummyBool = true
    static var previews: some View {
        AddItemView(addItemViewPresented: $dummyBool)
    }
}
