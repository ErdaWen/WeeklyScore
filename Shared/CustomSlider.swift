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
        HStack(alignment: .bottom, spacing: 10){
            
            Image(systemName: "minus.magnifyingglass")
                .resizable().scaledToFit()
                .frame(height:18)
                .foregroundColor(Color("text_black").opacity(0.3))
                
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color("text_black").opacity(0.3))
                        .frame(height:2)
                    Circle()
                        .foregroundColor(Color("text_black"))
                        .frame(width: 10 )
                        .padding(.leading, geometry.size.width * CGFloat((interCord-minValue)/(maxValue-minValue))-5)
                }
                .frame(height:55)
                .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ value in
                                interCord
                                    = min(max(minValue,
                                              minValue + Double(value.location.x) / Double(geometry.size.width) * (maxValue - minValue)
                                    ) , maxValue)
                            }))
            } // end geoReader
            
            Image(systemName: "plus.magnifyingglass")
                .resizable().scaledToFit()
                .frame(height:18)
                .foregroundColor(Color("text_black").opacity(0.3))
        }
        
        
    }
}

//struct CustomSlider_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomSlider()
//    }
//}