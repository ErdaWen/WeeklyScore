//
//  tabButton.swift
//  WeeklyScore (iOS)
//
//  Created by Erda Wen on 10/2/22.
//

import SwiftUI

struct tabButton: View {
    var imageName: String
    var titleText: String
    var selected: Bool

    var body: some View {
        VStack(alignment:.center){
            
            Image (systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(selected ? Color("text_red") : Color("text_black"))
                .frame(height:20)
            if selected{
                RoundedRectangle(cornerRadius: 2.5)
                    .foregroundColor(Color("text_red"))
                    .frame(width:40, height: 5)
            }else{
                Text (titleText)
                    .font(.system(size: 10))
                    .foregroundColor(Color("text_black"))
            }
        }
        .frame(width: 80)
        .animation(.default)
    }
}

//struct tabButton_Previews: PreviewProvider {
//    static var previews: some View {
//        tabButton()
//    }
//}
