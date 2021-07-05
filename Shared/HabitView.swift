//
//  HabitView.swift
//  WeeklyScore
//
//  Created by Xiaozhen Yang on 7/4/21.
//

import SwiftUI

struct HabitView: View {
    @EnvironmentObject var entryModel:EntryModel
    @EnvironmentObject var habitModel:HabitModel
    var body: some View {
        List(habitModel.habits){ r in
            HStack{
                Text(r.title)
                Text(String(r.hoursTotal))
            }            
        }
        .padding()
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView()
    }
}
