//
//  ContentView.swift
//  Shared
//
//  Created by Erda Wen on 7/3/21.
//

import SwiftUI



struct ContentView: View {
    
    
    @State var tabIndex = 0
    var body: some View {
        
        TabView(selection: $tabIndex){
            Text("Calendar View")
                .padding()
                .tabItem {
                    VStack{
                        Image (systemName: "calendar")
                        Text ("Schedule")
                    }
                }.tag(0)
            
            Text("Habbit View")
                .padding()
                .tabItem {
                    VStack{
                        Image (systemName: "star")
                        Text ("Habits")
                    }
                }.tag(1)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
