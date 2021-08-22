//
//  SettingView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/25/21.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("nightMode") private var nightMode = true
    @AppStorage("weekStartDay") private var weekStartDay = 0
    @AppStorage("autoCompleteMode") private var autoCompleteMode = 1
    
    
    
    var body: some View {
        VStack{
            ZStack(alignment:.top){
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("tag_color_red").opacity(0.1))
                VStack(alignment:. leading){
                    Picker("Period starts from", selection: $weekStartDay) {
                        Text("Sunday").tag(0)
                        Text("Monday").tag(1)
                        Text("Tuesday").tag(2)
                        Text("Wednesday").tag(3)
                        Text("Thursday").tag(4)
                        Text("Friday").tag(5)
                        Text("Saturday").tag(6)
                    }.pickerStyle(MenuPickerStyle())
                    .foregroundColor(Color("text_black"))
                    
                }
            }.frame(height:400)
            
            
            
        }.padding(20)
        
        
        
        
        
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
