//
//  ScheduleListView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/26/21.
//

import SwiftUI

struct ScheduleListView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @FetchRequest var schedules: FetchedResults<Schedule>

    @Environment(\.managedObjectContext) private var viewContext
    
    @State var addViewPresented = false
    @State var zoomin = true
    
    var body: some View {
        VStack{
            ZStack(alignment:.top){
                
                ScrollView{
                    Spacer()
                        .frame(height:25)
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
                                                .foregroundColor(Color("text_black").opacity(0.5))
                                                .font(.system(size: 12))
                                                .padding(.top,5)
                                        } else {
                                            Text("Today")
                                                .foregroundColor(Color("text_black").opacity(0.5))
                                                .font(.system(size: 12))
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
                                            ScheduleTileView(schedule: schedule)
                                                .frame(height: zoomin ? 65 : 45)
                                        }
                                    }
                                }

                            }// end divider ForEach
//
//                            ForEach(schedules){ schedule in
//
//                                    ScheduleTileView(schedule: schedule)
//                                        .frame(height: zoomin ? 65 : 45)
//
//                            }
                        }
                        .padding(.horizontal,20)
                    }
                    
                    else {
                        Text("No schedules for the selected week")
                            .foregroundColor(Color("text_black"))
                            .fontWeight(.light)
                            .font(.system(size: 12))
                    }
                } //end ScoreView
                .animation(.default)
                
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
                    Button {
                        zoomin.toggle()
                    } label: {
                        if schedules.count != 0 {
                            Image(systemName: zoomin ? "minus.magnifyingglass" : "arrow.up.left.and.down.right.magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 10)
                                .frame(height:22)
                                .foregroundColor(Color("text_black"))
                                .background(
                                    RadialGradient(gradient: Gradient(colors: [.white.opacity(1),.white.opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                                )
                        }
                    }
                    Spacer()
                } //end Buttons HStack
                
            }
            
        }
    }
}

//struct ScheduleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListView()
//    }
//}
