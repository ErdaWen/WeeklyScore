//
//  ContentView.swift
//  Shared
//
//  Created by Erda Wen on 7/3/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var habitModel = HabitModel()
    @ObservedObject var entryModel = EntryModel()
    @State var tabIndex = 1
    
    var body: some View {
        
        TabView(selection: $tabIndex){
            ScheduleView()
                .tabItem {
                    VStack{
                        Image (systemName: "calendar")
                        Text ("Schedule")
                    }
                }.tag(1)
            HabitView()
                .tabItem {
                    VStack{
                        Image (systemName: "star")
                        Text ("Habits")
                    }
                }.tag(2)
        }
        .environmentObject(HabitModel())
        .environmentObject(EntryModel())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
