//
//  HabitView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI

struct HabitView: View {
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    
    @State var addViewPresented = false
    @State var changeViewPresented = false
    
    var body: some View {
        VStack{
            if habitModel.habits.count > 0{
                TabView{
                    ForEach(0..<habitModel.habits.count,id: \.self) { r in
                        //if habitModel.habits[r].hidden == false {
                            HStack{
                                Button(habitModel.habits[r].title) {
                                    changeViewPresented = true
                                }.sheet(isPresented: $changeViewPresented, content: {
                                    ChangeHabitView(changeHabitViewPresented: $changeViewPresented, habitIndex: r)
                                })
                                if habitModel.habits[r].durationBased {
                                    Text("Total \(habitModel.habits[r].hoursTotal) hours")
                                } else {
                                    Text("\(habitModel.habits[r].checkedEntryNum) times hited")
                                }
                                Text(String(habitModel.habits[r].scoreTotal))
                            }
                        //}
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
            Button("Add Habit") {addViewPresented.toggle()}.sheet(isPresented: $addViewPresented, content: {
                AddHabitView(addHabitViewPresented: $addViewPresented)
            })
        }
        .padding()
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView().environmentObject(HabitModel()).environmentObject(EntryModel())
    }
}
