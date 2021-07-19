//
//  HabitView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    
    @FetchRequest(sortDescriptors: [],animation: .default)
    private var items: FetchedResults<Item>
    
    @State var addViewPresented = false
    @State var changeViewPresented = false
    @State var statScore = 0
    @State var statScoreGained = 0
    
    var body: some View {
        VStack{
            HStack(spacing:20){
                Text("Static")
                Text("\(statScoreGained)/\(statScore)")
            }.onAppear(){
                let statScores = entryModel.calculateScore(weekOffset: 0)
                statScore = statScores.0
                statScoreGained = statScores.1
            }
            if habitModel.habits.count > 0{
                TabView{
                    ForEach(0..<habitModel.habits.count,id: \.self) { r in
                        //if habitModel.habits[r].hidden == false {
                            HStack{
                                Button(habitModel.habits[r].title) {
                                    changeViewPresented = true
                                }.sheet(isPresented: $changeViewPresented, content: {
                                    ChangeItemView(changeHabitViewPresented: $changeViewPresented, habitIndex: r)
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
                AddItemView(addHabitViewPresented: $addViewPresented)
            })
        }
        .padding()
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView().environmentObject(HabitModel()).environmentObject(EntryModel())
    }
}
