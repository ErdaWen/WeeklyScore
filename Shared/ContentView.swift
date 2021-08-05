//
//  ContentView.swift
//  Shared
//
//  Created by Erda Wen on 7/3/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var tabIndex = 1
    
    var body: some View {
        
        TabView(selection: $tabIndex){
            // MARK: Schedule View
            ScheduleView()
                .tabItem {
                    VStack{
                        Image (systemName: "calendar.badge.clock")
                        Text ("Schedule").fontWeight(.light)
                    }
                }.tag(1)
            // MARK: Habit View
            ItemView()
                .tabItem {
                    VStack{
                        Image (systemName: "flag")
                        Text ("Habits").fontWeight(.light)
                    }
                    
                }.tag(2)
            SettingView()
                .tabItem{
                    VStack{
                        Image (systemName:"gear")
                        Text("Settings").fontWeight(.light)
                    }
                }.tag(3)
        }
        .onAppear(){
            let mode = UserDefaults.standard.integer(forKey: "autoCompleteMode")
            if mode != 3 {
                let changedSchedules = AutoRecordServer.autoRecord(mode: mode, weekStart: DateServer.startOfThisWeek())
                print(changedSchedules)
            }
            // Auto recored
            // propertiesModel.updateScores()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
