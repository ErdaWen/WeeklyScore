//
//  ContentView.swift
//  Shared
//
//  Created by Erda Wen on 7/3/21.
//

import SwiftUI



struct ContentView: View {
    
    var habitModel = HabitModel()
    var entryModel = EntryModel()
    @State var tabIndex = 1
    
    var body: some View {
        
        TabView(selection: $tabIndex){
            List(entryModel.entries){ r in
                VStack{
                    Text(r.habitTitle)
                    Text(entryModel.printTime(inputTime: r.beginTime))
                    Text(entryModel.printTime(inputTime: r.endTime))
                }
            }
                .padding(.leading, 14.0)
                .tabItem {
                    VStack{
                        Image (systemName: "calendar")
                        Text ("Schedule")
                    }
                }.tag(1)
            
            List(habitModel.habits){ r in
                HStack{
                    Text(r.title)
                    Text(String(r.hoursTotal))
                }
                
            }
                .padding()
                .tabItem {
                    VStack{
                        Image (systemName: "star")
                        Text ("Habits")
                    }
                }.tag(2)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
