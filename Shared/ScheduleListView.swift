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
    
    @State var addViewPresented = false
    @State var schedules = [Schedule]()
    @State var zoomin = true
    
    func initiateView() {
        schedules = []
        print(schedules)
        let endDate = DateServer.addOneWeek(date: propertiesModel.startDate)
        let fetchRequest = Schedule.schedulefetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(beginTime >= %@) AND (beginTime < %@)", propertiesModel.startDate as NSDate, endDate as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "beginTime", ascending: true)]
        do {
            schedules = try viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        print("Fetched starts " + DateServer.printTime(inputTime: propertiesModel.startDate))
        print("Fetched ends " + DateServer.printTime(inputTime: endDate))
        print(schedules)
        
    }
    
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
                                if dayLookingAt == DateServer.startOfToday() {
                                    Text("Today")
                                        .foregroundColor(Color("text_black").opacity(0.5))
                                        .font(.system(size: 12))
                                } else if dayLookingAt == DateServer.minusOneDay(date: DateServer.startOfToday()) {
                                    Text("Yesterday")
                                        .foregroundColor(Color("text_black").opacity(0.5))
                                        .font(.system(size: 12))
                                } else if dayLookingAt == DateServer.addOneDay(date: DateServer.startOfToday()) {
                                    Text("Tomorrow")
                                        .foregroundColor(Color("text_black").opacity(0.5))
                                        .font(.system(size: 12))
                                } else {
                                    Text(DateServer.printWeekday(inputTime: dayLookingAt))
                                        .foregroundColor(Color("text_black").opacity(0.5))
                                        .font(.system(size: 12))
                                }
//                                ForEach(schedules){ schedule in
//                                    if (schedule.beginTime >= dayLookingAt) && (schedule.beginTime < DateServer.addOneDay(date: dayLookingAt) ){
//                                        ScheduleTileView(schedule: schedule)
//                                            .frame(height: zoomin ? 65 : 45)
//                                    }
//                                }
                            }// end divider ForEach
                            
                            ForEach(schedules){ schedule in
                                
                                    ScheduleTileView(schedule: schedule)
                                        .frame(height: zoomin ? 65 : 45)
                                
                            }
                        }
                        .padding(.horizontal,20)
                    }
                    
                    else {
                        Text("No entries for the selected week")
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
        .onAppear(){
            print("\n")
            print("Start date initiated as " + DateServer.printTime(inputTime: propertiesModel.startDate))
            initiateView()
        }
        .onChange(of: propertiesModel.startDate) { _ in
            print("\n")
            print("Start date changes to " + DateServer.printTime(inputTime: propertiesModel.startDate))
            initiateView()
            
        }
    }
}

//struct ScheduleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListView()
//    }
//}
