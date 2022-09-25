//
//  ScheduleListPreviewView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/5/21.
//

import SwiftUI

struct ScheduleWeekCalendarView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var schedules: FetchedResults<Schedule>
    var interCord: Double
    @State var timeNow = Date()
    
    let updateTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    
    let mPicker:CGFloat = 40
    let topSpacing:CGFloat = 30
    let bottomSpacing:CGFloat = 50
    
    var body: some View {
        
        ScrollViewReader { scrollview in
            ScrollView{
                // Whole Zstack
                ZStack{
                    verLine
                    VStack(alignment: .leading, spacing: 0){
                        Spacer().frame(height:topSpacing)
                        ZStack(alignment: .topLeading){
                            GeometryReader {proxy in
                                Color.clear.preference(key: ScrollPreferenceKey.self,
                                                       value: -proxy.frame(in: .named("scroll")).minY)
                            }
                            .onPreferenceChange(ScrollPreferenceKey.self) { value in
                                propertiesModel.scrollPosition = value
                            }

                            scrollLocator
                            
                            timeLine

                            ScheduleWeekCalendarContentView(schedules: schedules,
                                                            interCord: interCord,
                                                            timeNow:timeNow)
                                .padding(.horizontal, mPicker) // end ZStack with picker frame
                            
                            //MARK:Now line
                            if propertiesModel.startDate == DateServer.startOfThisWeek() {
                                nowLine
                            }//end now line if
                        }// end everything except verticle line (and spacer) Zstack
                        Spacer().frame(height:bottomSpacing)
                    }// end everything excepet vertical line Vstack
                }// end whole ZStack
            }//end scrollView
            .coordinateSpace(name: "scroll")
            .onAppear(){
                scrollview.scrollTo(10032,anchor: .top)
            }
            .onReceive(updateTimer) { _ in
                timeNow = Date()
            }
        }// end scrollReader
    }//end body
    
    var verLine: some View {
        ZStack{
            GeometryReader { geo in
                HStack(spacing:0){
                    ForEach(-1...6,id: \.self){ offDay in
                        HStack{
                            Spacer()
                            Divider()
                        }
                        .padding(.vertical, -200)
                        .frame(width: geo.frame(in: .global).width / 8)
                    }
                }
            }// end GeoReader
        }.padding(.horizontal, mPicker) //end vertical lines
    }
    
    var scrollLocator: some View{
        VStack{
            ForEach(10000..<10101,id:\.self){r in
                Spacer().id(r)
            }
        }
    }
    
    var timeLine: some View{
        ForEach (0...24, id:\.self){ r in
            HStack(alignment:.center, spacing:5){
                Text("\(r):00")
                    .foregroundColor(Color("text_black").opacity(0.5))
                    .font(.system(size: 12))
                    .padding(.leading, 40)
                VStack{
                    Divider().padding(.trailing, mPicker)
                }
            }
            .frame(height:10)
            .padding(.top, CGFloat( Double(r) * interCord) )
        }
    }
    
    var nowLine:some View{
        NowLine(timeNow: timeNow, interCord: interCord)
            .padding(.leading, 17)
            .padding(.trailing, mPicker)
    }
}

//struct ScheduleListPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListPreviewView()
//    }
//}
