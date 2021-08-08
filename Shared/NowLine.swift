//
//  NowLine.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/7/21.
//

import SwiftUI

struct NowLine: View {
    var timeNow:Date
    var interCord: Double
    
    var body: some View {
        let startMin = DateServer.getMinutes(date: timeNow)
        let startCord = interCord * Double(startMin) / 60.0
        VStack{
            Spacer()
                .frame(height:CGFloat(startCord))
            HStack(alignment:.center, spacing:5){
                Text("Now")
                    .foregroundColor(Color("text_red"))
                    .font(.system(size: 12))
                    .padding(.leading, 25)
                    .background(
                        RadialGradient(gradient: Gradient(colors: [Color("background_white").opacity(1),Color("background_white").opacity(0)]), center: .center, startRadius: 2, endRadius: 10)
                    )
                VStack{
                    Rectangle()
                        .fill(Color("text_red"))
                        .frame(height:1.5)
                }
            }
            .frame(height:10)
            Spacer()
        }
        
    }
}

//struct NowLine_Previews: PreviewProvider {
//    static var previews: some View {
//        NowLine()
//    }
//}
