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
    var today:Date
    @State var timeNow = Date()
    @State var addViewPresented = false
    @State var batchAddViewPresented = false

    //Use factor for list style view
    var factor:CGFloat
    //Use interCord for calender style view
    var interCord:CGFloat
    
    let updateTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    @GestureState var pinchStarted = false
    //@State var pinchValue: CGFloat = 0
    //@State var lastInterCord = 50.0
    
    let mButtonUp:CGFloat = 0
    let sButton:CGFloat = 22
    let mButtons:CGFloat = 10
    let topSpacing:CGFloat = 30
    let bottomSpacing:CGFloat = 50
    
    var body: some View {
        ScrollViewReader { scrollview in
            ZStack(alignment: .top){
                ScrollView{
                    Spacer()
                        .frame(height:topSpacing)
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
                        ScheduleDayContentView(schedules: schedules, interCord: interCord,today:today)
                        
                        //MARK:Now line
                        if propertiesModel.startDate == DateServer.startOfToday() {
                            NowLine(timeNow: timeNow, interCord: interCord)
                        }
                        
                    } // end ZStack
                    .padding(.trailing , 20)
                    Spacer()
                        .frame(height:bottomSpacing)
                } // end scrollView
                .onAppear(){
                    scrollview.scrollTo(17)
                }
                
                //MARK: Buttons
                HStack (spacing:mButtons) {
                    Spacer()
                    
                    FloatButton(systemName: "plus.square", sButton: sButton) {
                        addViewPresented = true
                    }
                    .sheet(isPresented: $addViewPresented, content: {
                        AddScheduleView(initDate: propertiesModel.startDate, addScheduleViewPresented: $addViewPresented)
                            .environment(\.managedObjectContext,self.viewContext)
                    })
                    
                    
                    FloatButton(systemName: "plus.square.on.square", sButton: sButton) {
                        batchAddViewPresented = true
                    }
                    .sheet(isPresented: $batchAddViewPresented) {
                        DayBatchOperationView(dayStart: propertiesModel.startDate, schedules: schedules, singleDay: true, addBatchScheduleViewPresented: $batchAddViewPresented)
                            .environment(\.managedObjectContext,self.viewContext)
                    }
                    Spacer()
                } // end button HStack
                .padding(.top,mButtonUp)
                
                //MARK: "No schedules" overlay
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
                
                //MARK: Slider
//                VStack{
//                    Spacer()
//                    ZStack{
//                        Rectangle()
//                            .fill(LinearGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0.6),Color("background_white").opacity(0)]), startPoint: .bottom, endPoint: .top))
//                        CustomSlider(interCord: $interCord, minValue: 35, maxValue: 90)
//                            .frame(height:38)
//                            .padding(.leading,80)
//                            .padding(.trailing,70)
//                    }.frame(height:75)
//                }
                
                
                
            }         // end button + scroll ZStack
            .onReceive(updateTimer) { _ in
                timeNow = Date()
            }
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
