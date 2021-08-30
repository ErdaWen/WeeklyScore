//
//  WidgetScheduleTile.swift
//  WeeklyScoreWidgetExtension
//
//  Created by Erda Wen on 8/29/21.
//

import SwiftUI

struct WidgetScheduleTile: View {
    let fsSub:CGFloat = 8
    let fsTitle:CGFloat = 10.5
    let rTile:CGFloat = 8
    let opTile:Double = 0.2
    let wHandle:CGFloat = 6
    let mHandle:CGFloat = 3
    let pTextVer:CGFloat = 3
    
    var schedule:ScheduleProperties
    var body: some View {
        VStack(alignment:.leading,spacing:0){
            if schedule.durationBased {
                Text(schedule.beginTimeString + " - " + schedule.endTimeString)
                    .foregroundColor(Color("text_black"))
                    .font(.system(size: fsSub))
                    //.fontWeight(.light)
                    .padding(.leading,10)
            } else {
                Text(schedule.beginTimeString)
                    .foregroundColor(Color("text_black"))
                    .font(.system(size: fsSub))
                    //.fontWeight(.light)
                    .padding(.leading,10)
            }
            HStack(spacing:0){
                //MARK: Handler
                if schedule.durationBased {
                    RoundedRectangle(cornerRadius: wHandle/2)
                        .frame(width: wHandle)
                        .foregroundColor(schedule.color)
                        .padding(.trailing, mHandle)
                } else {
                    Circle()
                        .frame(width: wHandle+2)
                        .foregroundColor(schedule.color)
                        .padding(.trailing, mHandle-2)
                }
                
                ZStack(alignment:.top){
                    //MARK: Background tile
                    RoundedRectangle(cornerRadius: rTile).foregroundColor(schedule.color.opacity(opTile))
                    HStack{
                        Text(schedule.title)
                            .font(.system(size: fsTitle))
                            .foregroundColor(schedule.colortext)
                            .padding(.top,pTextVer)
                            .padding(.leading,5)
                        Spacer()
                        Text("\(schedule.score)")
                            .font(.system(size: fsTitle))
                            .foregroundColor(Color("text_black"))
                            //.fontWeight(.light)
                            .padding(.top,pTextVer)
                            .padding(.trailing,5)
                    }
                } // End center tile ZStack
            } // end content Hstack
        }// end everything Vstack
        
    }
}
//
//struct WidgetScheduleTile_Previews: PreviewProvider {
//    static var previews: some View {
//        WidgetScheduleTile()
//    }
//}
