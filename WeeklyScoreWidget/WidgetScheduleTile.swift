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
    let pTextVerCompact:CGFloat = 3
    let rShadow:CGFloat = 2
    let opShadow = 0.1

    


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
                        .font(.system(size: compact ? fsSubCompact : fsSub))
                        //.fontWeight(.light)
                        .padding(.leading,10)
                } else {
                    let timeString = DateServer.printShortTime(inputTime: schedule.beginTime) + " - " + DateServer.printShortTime(inputTime: schedule.endTime)
                    Text(timeString)
                        .foregroundColor(Color("text_black"))
                        .font(.system(size: compact ? fsSubCompact : fsSub))
                        //.fontWeight(.light)
                        .padding(.leading,10)
                }
                
            } else {
                if schedule.beginTime >= DateServer.addOneDay(date: DateServer.startOfToday()){
                    let timeString = DateServer.printShortTime(inputTime: schedule.beginTime) + " (tomorrow)"
                    Text(timeString)
                        .foregroundColor(Color("text_black"))
                        .font(.system(size: compact ? fsSubCompact : fsSub))
                        //.fontWeight(.light)
                        .padding(.leading,10)
                } else {
                    let timeString = DateServer.printShortTime(inputTime: schedule.beginTime)
                    Text(timeString)
                        .foregroundColor(Color("text_black"))
                        .font(.system(size: compact ? fsSubCompact : fsSub))
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
                        .shadow(color: Color("text_black").opacity(opShadow*2),
                                radius: rShadow, x:0, y:0)
                } else {
                    Circle()
                        .frame(width: wHandle+2)
                        .foregroundColor(schedule.color)
                        .padding(.trailing, mHandle-2)
                        .shadow(color: Color("text_black").opacity(opShadow*2),
                                radius: rShadow, x:0, y:0)
                }
                
                ZStack(alignment:.top){
                    //MARK: Background tile
                    RoundedRectangle(cornerRadius: rTile).foregroundColor(schedule.color.opacity(opTile))
                        .shadow(color: Color("text_black").opacity(opShadow*2),
                                radius: rShadow, x:0, y:0)
                    HStack{
                        Text(schedule.title)
                            .font(.system(size: compact ? fsTitleCompact : fsTitle))
                            .fontWeight(.semibold)
                            .foregroundColor(schedule.colortext)
                            .padding(.top,compact ? pTextVerCompact : pTextVer)
                            .padding(.leading,5)
                        Spacer()
                        if schedule.score>0{
                            Text("\(schedule.score)")
                                .font(.system(size: compact ? fsTitleCompact : fsTitle))
                                .foregroundColor(Color("text_black"))
                                .fontWeight(compact ? .regular : .light)
                                .padding(.top,compact ? pTextVerCompact : pTextVer)
                                .padding(.trailing,5)
                        }
                        
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
