//
//  ScheduleListPreviewView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/5/21.
//

import SwiftUI

struct ScheduleListPreviewView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var schedules: FetchedResults<Schedule>
    var interCord: Double
    let mPicker:CGFloat = 40
    let topSpacing:CGFloat = 30
    let wThreshhold:CGFloat = 100
    
    var body: some View {
        
        ScrollViewReader { scrollview in
            ScrollView{
                // Whole Zstack
                ZStack{
                    //MARK: Vertical lines
                    ZStack{
                        GeometryReader { geo in
                            HStack(spacing:0){
                                ForEach(-1...6,id: \.self){ offDay in
                                    HStack{
                                        Spacer()
                                        Divider()

                                    }
                                    .frame(width: geo.frame(in: .global).width / 8)
                                }
                            }
                        }// end GeoReader
                    }.padding(.horizontal, mPicker) //end vertical lines
                    
                    // MARK:Everything except vertical line
                    VStack(alignment: .leading, spacing: 0){
                        // MARK: Spacing
                        Spacer()
                            .frame(height:topSpacing)
                        ZStack(alignment: .topLeading){
                            
                            //MARK: Horizental Timeline background
                            ForEach (0...24, id:\.self){ r in
                                HStack(alignment:.center, spacing:5){
                                    Text("\(r):00")
                                        .foregroundColor(Color("text_black").opacity(0.5))
                                        .font(.system(size: 12))
                                        .padding(.leading, 40)
                                    VStack{
                                        Divider().padding(.trailing, mPicker)
                                    }
                                    .id(r)
                                }
                                .frame(height:10)
                                .padding(.top, CGFloat( Double(r) * interCord) )
                            }// end timeline background
                            
                            
                            // Zstack within the picker frame
                            ZStack{
                                GeometryReader { geo in
                                    HStack(spacing:0){
                                        ForEach(-1...6,id: \.self){ offDay in
                                            if offDay != -1{
                                                let dayLookingAt = DateServer.genrateDateStemp(startOfWeek: propertiesModel.startWeek, daysOfWeek: offDay)
                                                let schedulesFiltered = schedules.filter { schedule in
                                                    return (schedule.beginTime >= dayLookingAt) && (schedule.endTime < DateServer.addOneDay(date: dayLookingAt))
                                                }
                                                // VStack that contains one days view
                                                
                                                ZStack(alignment: .top){
                                                    ForEach(schedulesFiltered){ schedule in
                                                        // Calcualte cordinate
                                                        let (startCord,heightCord) = CordServer.calculateCord(startTime: schedule.beginTime, endTime: schedule.endTime, today: dayLookingAt, unit: interCord, durationBased: schedule.items.durationBased)
                                                        
                                                        VStack(spacing:0){
                                                            Spacer()
                                                                .frame(height:CGFloat(startCord))
                                                            if geo.frame(in: .global).width / 8 < wThreshhold {
                                                                ScheduleTileCompactView(schedule: schedule)
                                                                    .frame(height:CGFloat(heightCord))
                                                            } else {
                                                                ScheduleTileView(schedule: schedule, showTime:false,showTitle:false)
                                                                    .frame(height:CGFloat(heightCord))
                                                            }
                                                            
                                                            Spacer()
                                                        }
                                                    }// end foreach
                                                    
                                                    //MARK:Today circle
                                                    if dayLookingAt == DateServer.startOfToday(){
                                                        let startMin = DateServer.getMinutes(date: Date())
                                                        let startCord = interCord * Double(startMin) / 60.0
                                                        VStack(spacing:0){
                                                            Spacer()
                                                                .frame(height:CGFloat(startCord)+1)
                                                            Circle().frame(height:8).foregroundColor(Color("text_red"))
                                                            Spacer()
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                .padding(.trailing, 2)
                                                .frame(width: geo.frame(in: .global).width / 8  )
                                            } else {
                                                VStack{}.frame(width: geo.frame(in: .global).width / 8 )
                                            }// end if offDay != -1
                                        } // end foreach -1...6
                                    }// end Hstack
                                }// end GeoReader
                            }.padding(.horizontal, mPicker) // end ZStack with picker frame
                            
                            //MARK:Now line
                            if propertiesModel.startDate == DateServer.startOfThisWeek() {
                                let startMin = DateServer.getMinutes(date: Date())
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
                                .padding(.leading, 17)
                                .padding(.trailing, mPicker)
                            }//end now line if
                            
                        }// end everything except verticle line (and spacer) Zstack
                    }// end everything excepet vertical line Vstack
                }// end whole ZStack
            }//end scrollView
            .onAppear(){
                scrollview.scrollTo(17)
            }
        }// end scrollReader

        
    }//end some view
}

//struct ScheduleListPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListPreviewView()
//    }
//}
