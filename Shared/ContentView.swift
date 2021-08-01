//
//  ContentView.swift
//  Shared
//
//  Created by Erda Wen on 7/3/21.
//

import SwiftUI

struct ContentView: View {
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
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
