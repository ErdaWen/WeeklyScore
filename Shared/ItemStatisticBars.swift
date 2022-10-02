//
//  ItemStatisticBars.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/13/21.
//

import SwiftUI

struct ItemStatisticBars: View {
    
    var dates:[Date]
    var values:[Int]
    var durationBased:Bool
    var color:Color
    
    let rTile:CGFloat = 8
    let rBar:CGFloat = 4
    let hBar:CGFloat = 20
    let maxheight:CGFloat = 100
    let fsSub:CGFloat = 10
    let fsTitle:CGFloat = 15
    
    var body: some View {
        ZStack(){
            RoundedRectangle(cornerRadius: rTile).foregroundColor(Color("background_white"))
            if dates.isEmpty {
                Text("🌵 No records")
                    .font(.system(size:fsTitle))
                    .foregroundColor(Color("text_black"))
                    .fontWeight(.regular)
            } else {
                //MARK: Real deal contents
                HStack(alignment:.bottom){
                    if let maxvalue = values.max(){
                        Spacer()
                        ForEach (0...5, id: \.self) { r in
                            VStack(spacing:2){
                                if durationBased {
                                    Text(DateServer.describeMinR(min: values[r]) )
                                        .font(.system(size:fsSub))
                                        .foregroundColor(Color("text_black"))
                                        .fontWeight(.regular)
                                } else {
                                    Text("\(values[r])")
                                        .font(.system(size:fsSub))
                                        .foregroundColor(Color("text_black"))
                                        .fontWeight(.regular)
                                }
                                RoundedRectangle(cornerRadius: rBar)
                                    .foregroundColor(color)
                                    .frame(width: hBar, height: max(CGFloat(values[r]) / CGFloat(maxvalue) * maxheight, 4) )
                                Text(DateServer.describeWeekLite(date: dates[r]))
                                    .font(.system(size:fsSub))
                                    .foregroundColor(Color(dates[r] == DateServer.startOfThisWeek() ? "text_red" : "text_black"))
                                    .fontWeight(.regular)
                            } // end VStack
                            Spacer()
                        }// end ForEach
                    }// end unwraper
                }// end HStack
                .padding(8)
            }
        }
        
    }
}


//
//struct ItemStatisticBars_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemStatisticBars()
//    }
//}
