//
//  ScheduleDayView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/31/21.
//

import SwiftUI

struct ScheduleDayView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var schedules: FetchedResults<Schedule>
    @State var timeNow = Date()
    @State var addViewPresented = false
    @State var interCord = 50.0
        
    
    var body: some View {
        ZStack(alignment: .top){
            
            ScrollView{
                Spacer()
                    .frame(height:30)
                ZStack(alignment: .topLeading){
                    //MARK: Timeline background
                    ForEach (0...24, id:\.self){ r in
                        HStack(alignment:.center, spacing:5){
                            Text("\(r):00")
                                .foregroundColor(Color("text_black").opacity(0.5))
                                .font(.system(size: 12))
                                .padding(.leading, 20)
                            VStack{
                                Divider()
                            }
                        }
                        .frame(height:10)
                        .padding(.top, CGFloat( Double(r) * interCord) )
                    }
                    // end time line plot VStack
                    
                    //MARK: All schedules
                    ForEach(schedules){ schedule in
                        
//                        let startMin = DateServer.getMinutes(date: schedule.beginTime)
//                        let endMin = DateServer.getMinutes(date: schedule.endTime)
//                        let startCord = 6 + interCord * Double(startMin) / 60.0
//                        let heightCord = max(interCord * Double(endMin - startMin) / 60.0, 25)
                        
                        let (startCord,heightCord) = CordServer.calculateCord(startTime: schedule.beginTime, endTime: schedule.endTime, today: propertiesModel.startDate, unit: interCord, durationBased: schedule.items.durationBased)
                        
                        //if schedule.items.durationBased{
                            VStack(spacing:0){
                                Spacer()
                                    .frame(height:CGFloat(startCord))
                                ScheduleTileView(schedule: schedule, showTime:false)
                                    .frame(height:CGFloat(heightCord))
                                    .padding(.leading, 50)
                                Spacer()
                            }
                            
//                        } else {
//
//                            VStack(spacing:0){
//                                Spacer()
//                                    .frame(height:CGFloat(startCord)-12.5)
//                                ScheduleTileView(schedule: schedule, showTime:false)
//                                    .frame(height:25)
//                                    .padding(.leading, 50)
//                                Spacer()
//                            }
//
//                        }
                    }
                    
                    //MARK:Now line
                    if propertiesModel.startDate == DateServer.startOfToday() {
                        let startMin = DateServer.getMinutes(date: timeNow)
                        let startCord = interCord * Double(startMin) / 60.0
                        VStack{
                            Spacer()
                                .frame(height:CGFloat(startCord))
                            HStack(alignment:.center, spacing:5){
                                Text("Now")
                                    .foregroundColor(Color("text_red"))
                                    .font(.system(size: 12))
                                    .padding(.leading, 20)
                                    .background(
                                        RadialGradient(gradient: Gradient(colors: [Color("background_white").opacity(1),Color("background_white").opacity(0)]), center: .center, startRadius: 2, endRadius: 10)
                                    )
                                VStack{
                                    Divider()
                                        .background(Color("text_red"))
                                }
                            }
                            .frame(height:10)
                            Spacer()
                        }
                        
                    } // end now bar
                    
                } // end ZStack
                .padding(.leading,0)
                .padding(.trailing , 20)
            } // end scrollView
            
            
            //MARK: Buttons
            HStack{
                Spacer()
                Button {
                    addViewPresented = true
                } label: {
                    Image(systemName: "plus.square")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 16)
                        .frame(height:22)
                        .foregroundColor(Color("text_black"))
                        .background(
                            RadialGradient(gradient: Gradient(colors: [Color("background_white").opacity(1),Color("background_white").opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                        )
                }
                .sheet(isPresented: $addViewPresented, content: {
                    AddScheduleView(initDate: propertiesModel.startDate, addScheduleViewPresented: $addViewPresented)
                })
                
                
                Button {
                    
                } label: {
                    Image(systemName: "plus.square.on.square")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 16)
                        .frame(height:22)
                        .foregroundColor(Color("text_black"))
                        .background(
                            RadialGradient(gradient: Gradient(colors: [Color("background_white").opacity(1),Color("background_white").opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                        )
                }
                Spacer()
            } // end button HStack
            .padding(.top,5)
            
            if schedules.count == 0{
                VStack(){
                    Spacer()
                    Text("No schedules for selected day")
                        .foregroundColor(Color("text_black"))
                        .font(.system(size: 18))
                        .fontWeight(.light)
                    Spacer()
                }
            }
            
        }// end button + scroll ZStack
        
    }
}

//struct ScheduleDayView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDayView()
//    }
//}
