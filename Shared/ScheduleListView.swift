//
//  ScheduleListView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/26/21.
//

import SwiftUI

struct ScheduleListView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest var schedules: FetchedResults<Schedule>
    @State var addViewPresented = false
    //@State var zoomin = UserDefaults.standard.bool(forKey: "zoomedIn")
    @State var factor = UserDefaults.standard.double(forKey: "listScaleFactor")
    
    let mHorizon:CGFloat = 20
    let mButtonUp:CGFloat = 10
    let sButton:CGFloat = 22
    let mButtons:CGFloat = 16
    let mTitleButton:CGFloat = 3
    let topSpacing:CGFloat = 40
    

    
    var body: some View {
        VStack{
            ZStack(alignment:.top){
                
                ScrollView{
                    Spacer()
                        .frame(height:topSpacing)
                    if schedules.count != 0{
                        VStack{
                            ForEach(0...6,id: \.self){ offDay in
                                let dayLookingAt = DateServer.genrateDateStemp(startOfWeek: propertiesModel.startWeek, daysOfWeek: offDay)
                                let schedulesFiltered = schedules.filter { schedule in
                                    return (schedule.beginTime >= dayLookingAt) && (schedule.beginTime < DateServer.addOneDay(date: dayLookingAt))
                                }
                                if (schedulesFiltered.count > 0) || (dayLookingAt == DateServer.startOfToday()){
                                    // Day Divider
                                    if dayLookingAt == DateServer.startOfToday() {
                                        if schedulesFiltered.count == 0 {
                                            Text("No schedules for today")
                                                .foregroundColor(Color("text_red"))
                                                .fontWeight(.bold)
                                                .font(.system(size: 12))
                                                .padding(.top,5)
                                        } else {
                                            Text("Today")
                                                .foregroundColor(Color("text_red"))
                                                .font(.system(size: 12))
                                                .fontWeight(.bold)
                                                .padding(.top,5)
                                        }
                                    } else if dayLookingAt == DateServer.minusOneDay(date: DateServer.startOfToday()) {
                                        Text("Yesterday")
                                            .foregroundColor(Color("text_black").opacity(0.5))
                                            .font(.system(size: 12))
                                            .padding(.top,5)
                                    } else if dayLookingAt == DateServer.addOneDay(date: DateServer.startOfToday()) {
                                        Text("Tomorrow")
                                            .foregroundColor(Color("text_black").opacity(0.5))
                                            .font(.system(size: 12))
                                            .padding(.top,5)

                                    } else {
                                        Text(DateServer.printWeekday(inputTime: dayLookingAt))
                                            .foregroundColor(Color("text_black").opacity(0.5))
                                            .font(.system(size: 12))
                                            .padding(.top,5)
                                    }
                                    
                                    ForEach(schedulesFiltered){ schedule in
                                        if (schedule.beginTime >= dayLookingAt) && (schedule.beginTime < DateServer.addOneDay(date: dayLookingAt) ){
                                            ScheduleTileView(schedule: schedule, showTime:true)
                                                .frame(height: CordServer.calculateHeight(startTime: schedule.beginTime, endTime: schedule.endTime, factor: factor,minHeight:25,maxHeight:100) + 20)
                                        }
                                    }
                                }

                            }// end divider ForEach
                        }
                        .padding(.horizontal, mHorizon)
                    } //end if there is schedule
                } //end ScoreView
                .animation(.default)
                
                //MARK: Buttons
                
                HStack{
                    Spacer()
                    Button {
                        addViewPresented = true
                    } label: {
                        Image(systemName: "plus.square")
                            .resizable().scaledToFit()
                            .padding(.horizontal, mButtons).frame(height:sButton)
                            .padding(.vertical, mTitleButton)
                            .foregroundColor(Color("text_black"))
                            .background(
                                RadialGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                            )
                    }
                    .sheet(isPresented: $addViewPresented, content: {
                        AddScheduleView(initDate: Date(),addScheduleViewPresented: $addViewPresented)
                    })
                    
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "plus.square.on.square")
                            .resizable().scaledToFit()
                            .padding(.horizontal, mButtons).frame(height:sButton)
                            .padding(.vertical, mTitleButton)
                            .foregroundColor(Color("text_black"))
                            .background(
                                RadialGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                            )
                    }
                    
                    Spacer()
                } //end Buttons HStack
                .padding(.top,mButtonUp)
                
                VStack{
                    Spacer()
                    CustomSlider_list(factor: $factor, minValue: 0, maxValue: 30)
                        .padding(.leading,80)
                        .padding(.trailing,70)
                        .padding(.bottom,18)
                        .frame(height:55)
                }
                
//                VStack{
//                    Spacer()
//                    Button {
//                        zoomin.toggle()
//                        UserDefaults.standard.set(zoomin,forKey: "zoomedIn")
//                    } label: {
//                        if schedules.count != 0 {
//                            Image(systemName: zoomin ? "minus.magnifyingglass" : "arrow.up.left.and.down.right.magnifyingglass")
//                                .resizable().scaledToFit()
//                                .padding(.horizontal, mButtons).frame(height:sButton)
//                                .padding(.vertical, 20)
//                                .foregroundColor(Color("text_black").opacity(0.5))
//                                .background(
//                                    RadialGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0)]), center: .center, startRadius: 5, endRadius: 15)
//                                )
//                        }
//                    }
//                }

                if schedules.count == 0 {
                    
                        VStack(){
                            Spacer()
                            Text("No schedules for selected week")
                                .foregroundColor(Color("text_black"))
                                .font(.system(size: 18))
                                .fontWeight(.light)
                            Spacer()
                        }
                    
                }
                
                
            }
            
        }
    }
}

//struct ScheduleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListView()
//    }
//}
