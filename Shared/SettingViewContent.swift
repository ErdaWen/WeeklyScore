//
//  SettingViewContent.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/21/21.
//

import SwiftUI

struct SettingViewContent: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    let fsSub:CGFloat = 12
    let rTile:CGFloat = 8
    let rTileOption:CGFloat = 6
    let fsOptions:CGFloat = 14
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading,spacing:10){
                Spacer().frame(height:10)
                weekStartDayPicker()// end picker
                Spacer().frame(height:10)
                autoCompleteModePicker()
                Spacer().frame(height:10)
                nightModePicker()
                
            }//end all Zstack
            .padding(.horizontal, 40)
            .padding(.vertical,20)
        }//end scrollview
        
    }
}

//struct SettingViewContent_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingViewContent()
//    }
//}