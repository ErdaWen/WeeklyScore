//
//  DayPicker.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/7/21.
//

import SwiftUI

struct DayPicker: View {
    var weekFromNow:Int
    @Binding var dayFromDay1:Int
    var previewMode: Bool
    
    let fsTitle:CGFloat = 18.0
    let fsSub:CGFloat = 12.0
    let pPickerTextVer:CGFloat = 3
    let mDateWeekday:CGFloat = 2

    
    var body: some View {
        ZStack(alignment:.leading){
            GeometryReader { geo in
                //MARK: Selection tile
//                Circle()
//                    .foregroundColor(Color("tag_color_orange"))
//                    .blur(radius: 10)
//                    .frame(width:30)
//                    .padding(.top,5)
//                    .frame(width:geo.frame(in: .global).width / 8)
//                    .padding(.leading, geo.frame(in: .global).width / 8 * CGFloat(dayFromDay1 + 1))
//                    .animation(.spring())
                
                HStack(spacing:0){
                    //MARK: List icon
                    VStack(alignment: .center, spacing: 2){
                        Image(systemName: previewMode ? "calendar" : "list.dash")
                            .resizable().scaledToFit()
                            .padding(.top,8)
                            .frame(width: geo.frame(in: .global).width / 8 - 20, height: previewMode ? 24 : 20)
                            .padding(.bottom, 10)
                        // hide text "All" when selected
                        if (dayFromDay1 != -1)
                        {
                            Text("All").font(.system(size: fsSub))
                                .foregroundColor(Color("text_black"))
                                .padding(.top, -7)
                                .padding(.bottom,4)
                        }
                    }
                    .padding(.bottom,6)
                    .frame(width: geo.frame(in: .global).width / 8,height:42)
                    .padding(.top, pPickerTextVer)
                    .onTapGesture {
                        dayFromDay1 = -1
                    }
                    
                    //MARK: Seven days
                    let dayNumbers = DateServer.generateDays(offset:weekFromNow)
                    let weekdayNumbers = DateServer.generateWeekdays(offset:weekFromNow)
                    
                    ForEach(0...6, id:\.self){ r in
                        let isToday = DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: r) == DateServer.startOfToday()
                        ZStack(){
                            VStack(alignment: .center, spacing: mDateWeekday){
                                
                                Text("\(dayNumbers[r])")
                                    .font(.system(size: fsTitle))
                                    .fontWeight(isToday ? .bold : .regular)
                                    .foregroundColor(isToday ?  Color("text_red") : Color("text_black"))
                                
                                if dayFromDay1 != r{
                                    Text("\(weekdayNumbers[r])")
                                        .font(.system(size: fsSub))
                                        .fontWeight(isToday ? .bold : .regular)
                                        .foregroundColor(isToday ?  Color("text_red") : Color("text_black"))
                                } else {
                                    Spacer().frame(height:6)
                                }

                            }
                            .padding(.bottom,4)
                            .animation(.default)
                            
                            // For preview mode, add verticle line to form a calendar look
                            if previewMode && (dayFromDay1 == -1 ){
                                HStack{
                                    Spacer()
                                    Divider()
                                }
                            }
                        }
                        .frame(width: geo.frame(in: .global).width / 8,height:42)
                        .padding(.top, pPickerTextVer)
                        .onTapGesture {
                            dayFromDay1 = r
                        }
                    }// end seven days
                } // end 8 icons
                
                VStack{
                    Spacer()
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color("tag_color_orange"))
                        .frame(width: geo.frame(in: .global).width / 8,
                               height: 5)
                        .padding(.leading, geo.frame(in: .global).width / 8 * CGFloat(dayFromDay1 + 1))
                        .animation(.spring())
                }
                
            } //end GeoReader
        }
    }
}

//struct DayPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        DayPicker()
//    }
//}
