//
//  FloatButton.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/7/21.
//

import SwiftUI

struct FloatButton: View {
    var systemName:String
    var sButton: CGFloat
    var action: () -> Void
    
    let mButtonVer:CGFloat = 15
    let mButtonHor:CGFloat = 15
    let rBackgroundStart:CGFloat = 5
    let rBackgroundEnd:CGFloat = 20
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .resizable().scaledToFit()
                .frame(width:sButton,height:sButton)
                .padding(.horizontal, mButtonHor)
                .padding(.vertical, mButtonVer).foregroundColor(Color("text_black"))
                .background(
                    RadialGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0)]), center: .center, startRadius: rBackgroundStart, endRadius: rBackgroundEnd)
                )
        }
    }
}

//struct FloatButton_Previews: PreviewProvider {
//    static var previews: some View {
//        FloatButton()
//    }
//}
