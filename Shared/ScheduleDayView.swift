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
    
    @GestureState var pinchStarted = false
    //@State var pinchValue: CGFloat = 0
    @State var lastInterCord = 50.0
    
    let mButtonUp:CGFloat = 10
    let sButton:CGFloat = 22
    let mButtons:CGFloat = 16
    
    var body: some View {
        ScrollViewReader { scrollview in
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
                                .id(r)
                            }
                            .frame(height:10)
                            .padding(.top, CGFloat( Double(r) * interCord) )
                        }
                        // end time line plot VStack
                        
                        //MARK: All schedules
                        ForEach(schedules){ schedule in
                            // Calcualte cordinate
                            let (startCord,heightCord) = CordServer.calculateCord(startTime: schedule.beginTime, endTime: schedule.endTime, today: propertiesModel.startDate, unit: interCord, durationBased: schedule.items.durationBased)
                            
                            VStack(spacing:0){
                                Spacer()
                                    .frame(height:CGFloat(startCord))
                                ScheduleTileView(schedule: schedule, showTime:false)
                                    .frame(height:CGFloat(heightCord))
                                    .padding(.leading, 50)
                                Spacer()
                            }
                            
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
                .onAppear(){
                    scrollview.scrollTo(17)
                }
                
                //MARK: Buttons
                HStack{
                    Spacer()
                    Button {
                        addViewPresented = true
                    } label: {
                        Image(systemName: "plus.square")
                            .resizable().scaledToFit()
                            .padding(.horizontal, mButtons).frame(height:sButton)
                            .foregroundColor(Color("text_black"))
                            .background(
                                RadialGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                            )
                    }
                    .sheet(isPresented: $addViewPresented, content: {
                        AddScheduleView(initDate: propertiesModel.startDate, addScheduleViewPresented: $addViewPresented)
                    })
                    
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "plus.square.on.square")
                            .resizable().scaledToFit()
                            .padding(.horizontal, mButtons).frame(height:sButton)
                            .foregroundColor(Color("text_black"))
                            .background(
                                RadialGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                            )
                    }
                    Spacer()
                } // end button HStack
                .padding(.top,mButtonUp)
                
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
                
                VStack{
                    Spacer()
                    CustomSlider(interCord: $interCord, minValue: 35, maxValue: 90)
                        .padding(.horizontal,100)
                        .frame(height:20)
                }
                
            }         // end button + scroll ZStack
        } //end ScrollViewReader
//        .gesture(
//            MagnificationGesture()
//                //                    .updating($pinchStarted, body: { value, out, _ in
//                //                        out = true
//                //                    })
//                .onChanged({ value in
//
//                    print("value: \(value)")
//                    interCord = min(max(lastInterCord + Double(value-1)*30,35),90)
//
//
//                })
//                .onEnded({ value in
//                    lastInterCord = interCord
//
//
//                })
//        )
        
        
    }
}

//struct ScheduleDayView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDayView()
//    }
//}
