//
//  ContentView.swift
//  Shared
//
//  Created by Erda Wen on 7/3/21.
//

import SwiftUI

struct ContentView: View {
    @State var initzer = Initializer()
    
    @State var tabIndex = 1
    
    var body: some View {
        
        TabView(selection: $tabIndex){
            // MARK: Schedule View
            ScheduleView()
                .tabItem {
                    VStack{
                        Image (systemName: "calendar")
                        Text ("Schedule")
                    }
                }.tag(1)
            // MARK: Habit View
            ItemView()
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
