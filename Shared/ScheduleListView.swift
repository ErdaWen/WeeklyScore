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
    @State var zoomin = UserDefaults.standard.bool(forKey: "zoomedIn")
    
    let mButtonUp:CGFloat = 10
    let sButton:CGFloat = 22
    let mButtons:CGFloat = 10
    let mSec:CGFloat = 8
    
    var body: some View {
        VStack{
            ZStack(alignment:.top){
                
                ScrollViewReader { scrollView in
                    ScrollView{
                        Spacer()
                            .frame(height:30)
                            .onChange(of: propertiesModel.startDate) { _ in
                                scrollView.scrollTo(3,anchor: .top)
                            }
                        if schedules.count != 0{
                            //VStack{
                                ForEach(0...6,id: \.self){ offDay in
                                    // Fetch core data for single day
                                    let dayLookingAt = DateServer.genrateDateStemp(startOfWeek: propertiesModel.startWeek, daysOfWeek: offDay)
                                    let schedulesFiltered = schedules.filter { schedule in
                                        return (schedule.beginTime >= dayLookingAt) && (schedule.beginTime < DateServer.addOneDay(date: dayLookingAt))
                                    }
                                    if (schedulesFiltered.count > 0) || (dayLookingAt == DateServer.startOfToday()){
                                        // Day Divider
                                        if dayLookingAt == DateServer.startOfToday() {
                                            if schedulesFiltered.count == 0 {
                                                Text("No schedules for today")
                                                    .foregroundColor(Color("text_red")).font(.system(size: 12)).padding(.top,mSec)
                                                EmptyView()
                                                    .id(2)
                                            } else {
                                                Text("Today")
                                                    .foregroundColor(Color("text_red")).font(.system(size: 12)).padding(.top,mSec)
                                                EmptyView()
                                                    .id(2)
                                            }
                                        } else if dayLookingAt == DateServer.minusOneDay(date: DateServer.startOfToday()) {
                                            Text("Yesterday")
                                                .foregroundColor(Color("text_black").opacity(0.5)).font(.system(size: 12)).padding(.top,mSec)
                                        } else if dayLookingAt == DateServer.addOneDay(date: DateServer.startOfToday()) {
                                            Text("Tomorrow")
                                                .id(3)
                                                .foregroundColor(Color("text_black").opacity(0.5)).font(.system(size: 12)).padding(.top,mSec)
                                        } else {
                                            Text(DateServer.printWeekday(inputTime: dayLookingAt))
                                                .foregroundColor(Color("text_black").opacity(0.5)).font(.system(size: 12)).padding(.top,mSec)
                                        }
                                        
                                        ForEach(schedulesFiltered){ schedule in
                                            if (schedule.beginTime >= dayLookingAt) && (schedule.beginTime < DateServer.addOneDay(date: dayLookingAt) ){
                                                ScheduleTileView(schedule: schedule, showTime:true)
                                                    .frame(height: zoomin ? 65 : 45)
                                            }
                                        }
                                    }// end single day

                                }// end list ForEach
                            //}
                        }// end if
                    } //end ScheduleView
                    .onAppear(){
                        scrollView.scrollTo(2,anchor: .center)
                    }
                    .padding(.horizontal,20)
                    .animation(.default)
                }// end ScrollViewReader
                
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
                        AddScheduleView(initDate: Date(),addScheduleViewPresented: $addViewPresented)
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
                    Button {
                        zoomin.toggle()
                        UserDefaults.standard.set(zoomin,forKey: "zoomedIn")
                    } label: {
                        if schedules.count != 0 {
                            Image(systemName: zoomin ? "minus.magnifyingglass" : "arrow.up.left.and.down.right.magnifyingglass")
                                .resizable().scaledToFit()
                                .padding(.horizontal, mButtons).frame(height:sButton)
                                .foregroundColor(Color("text_black"))
                                .background(
                                    RadialGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                                )
                        }
                    }
                    Spacer()
                } //end Buttons HStack
                .padding(.top,mButtonUp)

                
            }
            
        }
    }
}

//struct ScheduleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListView()
//    }
//}
