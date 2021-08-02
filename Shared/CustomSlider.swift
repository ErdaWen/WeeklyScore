//
//  CustomSlider.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/2/21.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var interCord: Double
    var minValue:Double
    var maxValue:Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color("text_black").opacity(0.3))
                    .frame(height:2)
                Circle()
                    .foregroundColor(Color("text_black"))
                    .frame(width: 8 )
                    .padding(.leading, geometry.size.width * CGFloat((interCord-minValue)/(maxValue-minValue)))
            }
            .frame(height:10)
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            interCord
                                = min(max(minValue,
                                          minValue + Double(value.location.x) / Double(geometry.size.width) * (maxValue - minValue)
                                ) , maxValue)
                        }))
        }
        
    }
}

//struct CustomSlider_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomSlider()
//    }
//}
