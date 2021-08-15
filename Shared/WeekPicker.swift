//
//  WeekPicker.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/7/21.
//

import SwiftUI

struct WeekPicker: View {
    @Binding var weekFromNow:Int
    @Binding var dayFromDay1:Int
    var updateFunc: () -> Void
    
    let rTile:CGFloat = 12
    let sButton:CGFloat = 22
    let mButton:CGFloat = 10
    let fsTitle:CGFloat = 18.0

    var body: some View {
        ZStack{
            // Background tile
            RoundedRectangle(cornerRadius: rTile).foregroundColor(Color("background_grey"))
            
            HStack{
                //MARK: Week minus
                Button {
                    weekFromNow -= 1
                    //dayFromDay1 = -1
                    updateFunc()
                } label: {
                    //Image(systemName: "arrowtriangle.backward.square")
                    Image(systemName: "chevron.left")
                        .resizable().scaledToFit().frame(height:16).foregroundColor(Color("text_black"))
                }
                .frame(width: sButton, height: sButton).padding(.leading,mButton)
                
                Spacer()
                
                //MARK: Week restore
                Button {
                    weekFromNow = 0
                    //dayFromDay1 = -1
                    updateFunc()
                    
                } label: {
                    Text(weekFromNow == 0 ? "This week" : "Week of " + DateServer.generateStartDay(offset:weekFromNow) ).foregroundColor(Color("text_black")).font(.system(size: fsTitle)).fontWeight(.light)
                }
                
                Spacer()
                
                //MARK: Week plus
                Button {
                    weekFromNow += 1
                    //dayFromDay1 = -1
                    updateFunc()
                } label: {
                    //Image(systemName: "arrowtriangle.right.square")
                    Image(systemName: "chevron.right")
                        .resizable().scaledToFit().frame(height:16).foregroundColor(Color("text_black"))
                }
                .frame(width: sButton, height: sButton).padding(.trailing,mButton)
            }
        } // end ZStack
        
    }
}

//struct WeekPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekPicker()
//    }
//}
