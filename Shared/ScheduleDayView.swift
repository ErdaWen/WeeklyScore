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
    
    @State var addViewPresented = false
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
                            .padding(.top, CGFloat( Double(r) * 60.0) )
                        }
                    // end time line plot VStack
                    ZStack{
                        ForEach(schedules){ schedule in
                        
                        let startMin = DateServer.getMinutes(date: schedule.beginTime)
                        let endMin = DateServer.getMinutes(date: schedule.endTime)
                        let startCord = 6 + 60.0 * Double(startMin) / 60.0
                        let heightCord = max(60 * Double(endMin - startMin) / 60.0, 10)
                        
                        if schedule.items.durationBased{
                            VStack(spacing:0){
                                Spacer()
                                    .frame(height:CGFloat(startCord))
                                ScheduleTileView(schedule: schedule, showTime:false)
                                    .frame(height:CGFloat(heightCord))
                                    .padding(.leading, 50)
                                Spacer()
                            }
                         
                        } else {
                            
                            VStack(spacing:0){
                                Spacer()
                                    .frame(height:CGFloat(startCord)-12.5)
                                ScheduleTileView(schedule: schedule, showTime:false)
                                    .frame(height:25)
                                    .padding(.leading, 50)
                                Spacer()
                            }
                            
                        }
                        }
                    }

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
                        .padding(.horizontal, 10)
                        .frame(height:22)
                        .foregroundColor(Color("text_black"))
                        .background(
                            RadialGradient(gradient: Gradient(colors: [.white.opacity(1),.white.opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                        )
                }
                .sheet(isPresented: $addViewPresented, content: {
                    AddScheduleView(addScheduleViewPresented: $addViewPresented)
                })
                
                
                Button {
                    
                } label: {
                    Image(systemName: "plus.square.on.square")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 10)
                        .frame(height:22)
                        .foregroundColor(Color("text_black"))
                        .background(
                            RadialGradient(gradient: Gradient(colors: [.white.opacity(1),.white.opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                        )
                }
                Spacer()
            } // end button HStack
            .padding(.top,5)
            
            if schedules.count == 0{
                VStack(){
                    Spacer()
                    Text("No schedules for selected day")
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
