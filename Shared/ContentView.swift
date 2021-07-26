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
                   
                        Image (systemName: "calendar")

                    
                }.tag(1)
            // MARK: Habit View
            ItemView()
                .tabItem {
                    
                        Image (systemName: "star")
                    
                }.tag(2)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
