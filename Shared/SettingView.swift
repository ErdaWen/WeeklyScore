//
//  SettingView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/25/21.
//

import SwiftUI

struct SettingView: View {

    
    init(){
        Theme.navigationBarColors(background: UIColor(Color("tag_color_green").opacity(0.3)), titleColor: UIColor(Color("text_black")))
        }
    
    var body: some View {
        NavigationView{
            SettingViewContent()
                .navigationTitle("⚙️ Settings")
        }//End navigation View
    
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
