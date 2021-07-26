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
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    @Binding var changeItemViewPresented:Bool
    
    var item: Item
    
    @State var inputTitleIcon = ""
    @State var inputTitle = ""
    @State var inputDefaultScore:Int64 = 10
    @State var inputDefaultMinutes:Int64 = 0
    @State var inputDefaultMinutesString = "0"
    @State var inputDurationBased = false
    @State var tagid = 0 
    
    var body: some View {
        // Navigation Bar
        VStack{
            HStack{
                Button(action:{ changeItemViewPresented = false}
                       , label: {
                        Text("Cancel")
                            .foregroundColor(Color("text_red"))
                            .font(.system(size: 20))
                       })
                Spacer()
                Text("Edit Habit")
                    .font(.system(size: 20))

                Spacer()
                Button(action:{
                    // Check item name
                    //......
                    changeItemViewPresented = false
                    item.titleIcon = inputTitleIcon
                    item.title = inputTitle
                    item.defaultScore = inputDefaultScore
                    item.defaultMinutes = inputDefaultMinutes
                    item.tags = tags[tagid]
                    tags[tagid].lastUse = Date()
                    do{
                        try viewContext.save()
                        print("saved")
                        changeItemViewPresented = false
                    } catch {
                        print("Cannot save item")
                        print(error)
                    }
                }, label: {
                    Text("  Save")
                        .foregroundColor(Color("text_blue"))
                        .font(.system(size: 20))

                })
            }.padding(25)
            
            ScrollView{
                VStack(spacing:22){
                    HStack(spacing:10){
                        
                        // MARK:TitleIcon
                        VStack(alignment: .center, spacing: 8.0){
                            Text("Icon")
                                .font(.system(size: 15))
                                .foregroundColor(Color("text_black"))
                                .fontWeight(.light)
                            ZStack(alignment: .center){
                                RoundedRectangle(cornerRadius: 8.0)
                                    .stroke(Color(tags[tagid].colorName),style:StrokeStyle(lineWidth: 1.5))
                                EmojiTextField(text: $inputTitleIcon, placeholder: "")
                                    .font(.system(size: 50))
                                    .foregroundColor(Color("text_black"))
                                    .onChange(of: inputTitleIcon, perform: { value in
                                        if let lastChar = inputTitleIcon.last{
                                            inputTitleIcon = String(lastChar)
                                        }
                                        if inputTitleIcon.isEmpty{
                                            inputTitleIcon = "❓"
                                        }
                                    }).padding(15)
                                    .frame(width:50,height: 50)
                            }
                            .frame(width:50,height: 50)
                        }
                        
                        // MARK:Title
                        VStack(alignment: .leading, spacing: 7.0){
                            Text("Title")
                                .font(.system(size: 15))
                                .foregroundColor(Color("text_black"))
                                .fontWeight(.light)
                            ZStack(alignment: .center){
                                RoundedRectangle(cornerRadius: 8.0)
                                    .stroke(Color(tags[tagid].colorName),style:StrokeStyle(lineWidth: 1.5))
                                TextField("New Habit",text:$inputTitle)
                                    .font(.system(size: 20))
                                    .foregroundColor(Color("text_black"))
                                    .padding(.init(top: 3, leading: 5, bottom: 3, trailing: 5))
                            }
                            .frame(height: 50)
                        }
                    }.animation(.default)
                    
                    
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
                    
                    
                    HStack(spacing:10){
                        // MARK: Default score
                        VStack(alignment: .leading, spacing: 8.0){
                            Text("Default score")
                                .font(.system(size: 15))
                                .foregroundColor(Color("text_black"))
                                .fontWeight(.light)
                            ZStack(alignment: .center){
                                RoundedRectangle(cornerRadius: 8.0)
                                    .stroke(Color(tags[tagid].colorName),style:StrokeStyle(lineWidth: 1.5))
                                HStack{
                                    Text("\(inputDefaultScore)")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color("text_black"))
                                    Spacer()
                                    Stepper("", value: $inputDefaultScore, in: 0...20)
                                        .frame(width:100,height: 50)
                                }
                                .padding(.leading,10)
                                .padding(.trailing,10)
                            }
                        }
                        
                        // MARK:Default minutes
                        if inputDurationBased{
                            VStack(alignment: .leading, spacing: 7.0){
                                Text("Default minuite")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("text_black"))
                                    .fontWeight(.light)
                                ZStack(alignment: .center){
                                    RoundedRectangle(cornerRadius: 8.0)
                                        .stroke(Color(tags[tagid].colorName),style:StrokeStyle(lineWidth: 1.5))
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
                                        .font(.system(size: 20))
                                        .foregroundColor(Color("text_black"))
                                        .padding(.init(top: 3, leading: 5, bottom: 3, trailing: 5))
                                }
                                .frame(height: 50)
                            }
                        }
                    }.animation(.default)
                    
                    //MARK: Tags
                    VStack(alignment:.leading, spacing:7.0){
                        Text("Choose a tag")
                            .font(.system(size: 15))
                            .foregroundColor(Color("text_black"))
                            .fontWeight(.light)
                        ZStack{
                            RoundedRectangle(cornerRadius: 8.0)
                                .stroke(Color(tags[tagid].colorName),style:StrokeStyle(lineWidth: 1.5))
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
                        }
                    }
                    Button("Archive Habit...") {
                        // MARK: warning to be added
                        changeItemViewPresented = false
                        item.hidden = true
                    }
                    .foregroundColor(Color("text_blue"))
                    .font(.system(size: 20))
                    
                    Button("Delete Habit...") {
                        // MARK: warning to be added
                        changeItemViewPresented = false
                        viewContext.delete(item)
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
            inputDefaultScore = item.defaultScore
            inputDefaultMinutes = item.defaultMinutes
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
