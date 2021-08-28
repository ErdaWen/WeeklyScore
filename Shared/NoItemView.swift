//
//  NoItemView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/28/21.
//

import SwiftUI

struct NoItemView: View {
    var catagorized:Bool
    var body: some View {
        VStack(spacing:20){
            Spacer().frame(height:60)
            HStack(spacing:50){
                Image(systemName: "arrow.up")
                    .resizable().scaledToFit()
                    .foregroundColor(Color("text_black"))
                    .frame(width:15)
                if catagorized{
                    Spacer().frame(width:22)
                }
            }
            
            Text("🌵 You have no habits. Start by adding one.")
                .font(.system(size: 16))
                .foregroundColor(Color("text_black"))
                .padding(.horizontal,40)
        }
    }
}

//struct NoItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoItemView()
//    }
//}
