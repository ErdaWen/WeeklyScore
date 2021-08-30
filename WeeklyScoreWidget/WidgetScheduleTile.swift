//
//  WidgetScheduleTile.swift
//  WeeklyScoreWidgetExtension
//
//  Created by Erda Wen on 8/29/21.
//

import SwiftUI

struct WidgetScheduleTile: View {
    
    var schedule:ScheduleProperties
    var compact:Bool
    
    let fsSub:CGFloat = 10
    let fsSubCompact:CGFloat = 8
    let fsTitle:CGFloat = 12
    let fsTitleCompact:CGFloat = 10.5
    let rTile:CGFloat = 8
    let opTile:Double = 0.2
    let wHandle:CGFloat = 6
    let mHandle:CGFloat = 3
    let pTextVer:CGFloat = 5
    


    var body: some View {
        VStack(alignment:.leading,spacing:0){
//
//            if schedule.items.durationBased{
//                if schedule.endTime >= DateServer.addOneDay(date: DateServer.startOfToday()) {
//                    newScheduleProperty.endTimeString += " (tommorrow)"
//                }
//            } else {
//                if schedule.beginTime >= DateServer.addOneDay(date: DateServer.startOfToday()) {
//                    newScheduleProperty.beginTimeString += " (tommorrow)"
//                }
//            }
            
            
            
            if schedule.durationBased {
                if schedule.endTime >= DateServer.addOneDay(date: DateServer.startOfToday()){
                    let timeString = DateServer.printShortTime(inputTime: schedule.beginTime) + " - " + DateServer.printShortTime(inputTime: schedule.endTime) + " (tomorrow)"
                    Text(timeString)
                        .foregroundColor(Color("text_black"))
                        .font(.system(size: fsSub))
                        //.fontWeight(.light)
                        .padding(.leading,10)
                } else {
                    let timeString = DateServer.printShortTime(inputTime: schedule.beginTime) + " - " + DateServer.printShortTime(inputTime: schedule.endTime)
                    Text(timeString)
                        .foregroundColor(Color("text_black"))
                        .font(.system(size: fsSub))
                        //.fontWeight(.light)
                        .padding(.leading,10)
                }
                
            } else {
                if schedule.beginTime >= DateServer.addOneDay(date: DateServer.startOfToday()){
                    let timeString = DateServer.printShortTime(inputTime: schedule.beginTime) + " (tomorrow)"
                    Text(timeString)
                        .foregroundColor(Color("text_black"))
                        .font(.system(size: fsSub))
                        //.fontWeight(.light)
                        .padding(.leading,10)
                } else {
                    let timeString = DateServer.printShortTime(inputTime: schedule.beginTime)
                    Text(timeString)
                        .foregroundColor(Color("text_black"))
                        .font(.system(size: fsSub))
                        //.fontWeight(.light)
                        .padding(.leading,10)
                }
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
                            .fontWeight(.light)
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
