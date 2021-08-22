//
//  weekStartDayPicker.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/21/21.
//

import SwiftUI

struct weekStartDayPicker: View {
    @AppStorage("weekStartDay") private var weekStartDay = 0

    let fsSub:CGFloat = 12
    let rTile:CGFloat = 8
    let rTileOption:CGFloat = 6
    let fsOptions:CGFloat = 14
    let weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]

    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Every week period starts from:")
                .foregroundColor(Color("text_black"))
                .font(.system(size: fsSub))
                .fontWeight(.light)
            ZStack(alignment:.leading){
                Color("tag_color_blue").opacity(0.1)
                VStack(alignment: .leading, spacing: 0) {
                    ForEach (0...6, id: \.self) { r in
                        ZStack(alignment:.leading){
                            RoundedRectangle(cornerRadius: rTileOption)
                                .foregroundColor(Color("tag_color_blue").opacity(weekStartDay == r ? 0.4 : 0))
                                .padding(.horizontal,5)
                            Text(weekdays[r]).foregroundColor(Color("text_black"))
                                .font(.system(size: fsOptions)).fontWeight(.light).padding(.horizontal,20).padding(.vertical,5)
                        }
                        .onTapGesture {
                            withAnimation(.default){
                                weekStartDay = r
                            }
                        }
                    }
                }// end 7 terms Vstack
                .padding(.vertical,5)
            }//end tile Zstack
            .clipShape(RoundedRectangle(cornerRadius: rTile))
        }
    }
}

//struct weekStartDayPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        weekStartDayPicker()
//    }
//}
