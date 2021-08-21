//
//  AutoRecordNotificationBar.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/7/21.
//

import SwiftUI

struct AutoRecordNotificationBar: View {
    var count:Int
    var mode: Int
    
    let rBar:CGFloat = 8
    let fsText:CGFloat = 12
    let hBar:CGFloat = 20
    let mBarHor:CGFloat = 20
        
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: rBar)
                    .foregroundColor(Color( mode == 0 ? "text_green" : "text_red"))
                Text("\(count) " + (count == 1 ? "schedule " : "schedules ") + "marked as " + (mode == 0 ? "complete automatically" : "incomplete automatically"))
                    .font(.system(size: fsText))
                    .foregroundColor(Color("text_black"))
            }
            .frame(height:hBar)
            .padding(.horizontal,mBarHor)
            .transition(.opacity)
            Spacer()
        }
    }
}

//struct AutoRecordNotificationBar_Previews: PreviewProvider {
//    static var previews: some View {
//        AutoRecordNotificationBar()
//    }
//}
