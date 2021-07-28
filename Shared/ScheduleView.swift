//
//  ScheduleView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI
import UIKit

struct ScheduleView: View {
    
    @State var addViewPresented = false
    @State var showDeduct = false
    @State var weekFromNow = 0
    @State var dayNumbers:[Int] = [1, 2, 3, 4, 5, 6, 7]
    @State var weekdayNumbers:[String] = ["M", "T", "W", "T", "F", "S", "S"]
    @State var startDay = ""
    @State var dayFromDay1 = 0
    @State var selectedDateStart = Date()
    
    @Environment(\.managedObjectContext) private var viewContext    
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    
    var body: some View {
        VStack(spacing:0){
            //MARK: Score
            HStack(spacing:10){
                if showDeduct {
                    Text("-\(propertiesModel.deductScoreThisWeek)")
                        .font(.system(size: 25))
                        .foregroundColor(Color("text_red"))
                        .fontWeight(.light)
                } else{
                    Text("\(propertiesModel.gainedScoreThisWeek)")
                        .font(.system(size: 25))
                        .foregroundColor(Color("text_green"))
                        .fontWeight(.light)
                }
                Image(systemName: "line.diagonal")
                    .foregroundColor(Color("text_black"))
                Text("\(propertiesModel.totalScoreThisWeek)")
                    .font(.system(size: 25))
                    .foregroundColor(Color("text_black"))
                    .fontWeight(.light)
            }
            .onAppear(){
                propertiesModel.updateScores()
            }
            .onTapGesture {
                showDeduct.toggle()
            }
            .animation(.default)
            .padding(.bottom,2)
            
            //MARK: Score bar
            GeometryReader{ geo in
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color("text_black"),style:StrokeStyle(lineWidth: 1))
                    if propertiesModel.totalScoreThisWeek != 0 {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: geo.frame(in: .global)
                                    .width / CGFloat(propertiesModel.totalScoreThisWeek) * CGFloat(propertiesModel.gainedScoreThisWeek + propertiesModel.deductScoreThisWeek)
                            )
                            .foregroundColor(Color("text_green").opacity(0.6))
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: geo.frame(in: .global)
                                    .width / CGFloat(propertiesModel.totalScoreThisWeek) * CGFloat(propertiesModel.deductScoreThisWeek)
                            )
                            .foregroundColor(Color("text_red"))
                    }
                }
            }
            .frame(height:8)
            .padding(.leading,110)
            .padding(.trailing,110)
            .padding(.bottom,1)
            
            //MARK: WeekTitle
            ZStack{
                // Background tile
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("background_grey"))
                
                HStack{
                    //MARK: Week minus
                    Button {
                        weekFromNow -= 1
                        dayNumbers = DateServer.generateDays(offset:weekFromNow)
                        weekdayNumbers = DateServer.generateWeekdays(offset:weekFromNow)
                        startDay = DateServer.generateStartDay(offset:weekFromNow)
                        selectedDateStart = DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: max(dayFromDay1,0))
                    } label: {
                        Image(systemName: "arrowtriangle.backward.square")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("text_black"))
                    }
                    .frame(width: 20, height: 20)
                    .padding(.leading,10)
                    Spacer()
                    
                    //MARK: Week restore
                    Button {
                        weekFromNow = 0
                        dayNumbers = DateServer.generateDays(offset:weekFromNow)
                        weekdayNumbers = DateServer.generateWeekdays(offset:weekFromNow)
                        startDay = DateServer.generateStartDay(offset:weekFromNow)
                        selectedDateStart = DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: max(dayFromDay1,0))
                    } label: {
                        Text(weekFromNow == 0 ? "This week" : "Week of " + startDay )
                            .foregroundColor(Color("text_black"))
                            .font(.system(size: 16))
                            .fontWeight(.light)
                    }
                    
                    //MARK: Week plus

                    Spacer()
                    Button {
                        weekFromNow += 1
                        dayNumbers = DateServer.generateDays(offset:weekFromNow)
                        weekdayNumbers = DateServer.generateWeekdays(offset:weekFromNow)
                        startDay = DateServer.generateStartDay(offset:weekFromNow)
                        selectedDateStart = DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: max(dayFromDay1,0))
                    } label: {
                        Image(systemName: "arrowtriangle.right.square")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("text_black"))
                    }
                    .frame(width: 20, height: 20)
                    .padding(.trailing,10)
                }
            }
            .frame(height:38)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top,10)
            .animation(.default)
            
            //MARK: Day picker
            
            ZStack(alignment:.leading){
                GeometryReader { geo in
                    //MARK: Selection tile
                    Rectangle()
                        .frame(width:geo.frame(in: .global)
                                .width / 8)
                        .foregroundColor(Color("background_grey"))
                        .padding(.leading, geo.frame(in: .global)
                                    .width / 8 * CGFloat(dayFromDay1 + 1))
                        .animation(.default)

                    
                    //MARK: List icon
                    HStack(spacing:0){
                        VStack(alignment: .center, spacing: 2){
                            Image(systemName: "list.dash")
                                .resizable()
                                .scaledToFit()
                                .padding(.top,6)
                                .frame(width: geo.frame(in: .global)
                                        .width / 8 - 20 )
                            if (dayFromDay1 != -1)
                            {
                                Text("List")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("text_black"))
                                    .fontWeight(.light)
                                    .padding(.top, 6)
                            }
                        }
                        .frame(width: geo.frame(in: .global).width / 8 )
                        .onTapGesture {
                            dayFromDay1 = -1
                            selectedDateStart = DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: max(dayFromDay1,0))
                        }

                        //MARK: Seven days
                        ForEach(0...6, id:\.self){ r in
                            
                            VStack(alignment: .center, spacing: 2){
                                if (dayFromDay1 != -1)
                                {
                                    Text("\(dayNumbers[r])")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color("text_black"))
                                        .fontWeight(.light)
                                }
                                Text("\(weekdayNumbers[r])")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("text_black"))
                                    .fontWeight(.light)
                            }
                            .animation(.easeInOut)
                            .frame(width: geo.frame(in: .global)
                                    .width / 8 )
                            .padding(.top, 3)
                            .padding(.leading, 0)
                            .padding(.leading, 0)
                            .padding(.trailing, 0)

                            .onTapGesture {
                                dayFromDay1 = r
                                selectedDateStart = DateServer.genrateDateStemp(offset: weekFromNow, daysOfWeek: max(dayFromDay1,0))
                            }
                            
                        }
                    }
                }
                .onAppear(){
                    dayNumbers = DateServer.generateDays(offset:weekFromNow)
                    weekdayNumbers = DateServer.generateWeekdays(offset:weekFromNow)
                    startDay = DateServer.generateStartDay(offset:weekFromNow)
                }
            }
            .frame(height: (dayFromDay1 == -1) ? 25 : 45)
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .padding(.top,0)
            
            if dayFromDay1 == -1 {
                ScheduleListView(startDate:selectedDateStart)
            } else {
                
            }
            
            Spacer()
            
            Button("Add Schedule") {addViewPresented.toggle()}.sheet(isPresented: $addViewPresented, content: {
                AddScheduleView(addScheduleViewPresented: $addViewPresented)
            })
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
