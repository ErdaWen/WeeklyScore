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
    
    var body: some View {
        
        ScrollView{
            
//            // Whole Zstack
//            ZStack{
//                
//            }// end outer Zstack
//            
//            
            
            
            Spacer()
                .frame(height:topSpacing)
            ZStack(alignment: .topLeading){
                //MARK: Timeline background
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
                                                ScheduleTileCompactView(schedule: schedule)
                                                    .frame(height:CGFloat(heightCord))
                                                Spacer()
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 2)
                                    .frame(width: geo.frame(in: .global).width / 8 )
                                } else {
                                    VStack{}.frame(width: geo.frame(in: .global).width / 8 )
                                }// end if offDay != -1
                                Divider()
                            }
                            
                        }
                    }// end GeoReader
                }.padding(.horizontal, mPicker)
                
                
                
                
                GeometryReader { geo in
                    HStack(alignment: .top, spacing: 0){
                        ForEach(-1...6,id: \.self){ offDay in
                            
                        }// end forEach 0...6
                    }// end HStack
                    .padding(.horizontal, mPicker)
                }//end GeoReader
                
            }// end everything Zstack
        }//end scrollView
        
        
    }
}

//struct ScheduleListPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListPreviewView()
//    }
//}
