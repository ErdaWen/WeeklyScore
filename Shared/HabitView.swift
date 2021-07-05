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
    
    var body: some View {
        VStack{
            List(habitModel.habits){ r in
                HStack{
                    Text(r.title)
                    Text(String(r.hoursTotal))
                }
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
        HabitView()
    }
}
