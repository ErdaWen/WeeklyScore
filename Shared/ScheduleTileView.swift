//
//  ScheduleTileView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/29/21.
//

import SwiftUI

struct ScheduleTileView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    var schedule:Schedule
    
    @State var completionViewPresented = false
    @State var changeViewPresented = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            
            if schedule.items.durationBased {
                Text(DateServer.printShortTime(inputTime: schedule.beginTime) + " - " + DateServer.printShortTime(inputTime: schedule.endTime))
                    .foregroundColor(Color("text_black").opacity(0.5))
                    .font(.system(size: 12))
                    .padding(.leading, 20)
            } else {
                Text(DateServer.printShortTime(inputTime: schedule.beginTime))
                    .foregroundColor(Color("text_black").opacity(0.5))
                    .font(.system(size: 12))
                    .padding(.leading, 20)
            }
            
            
            HStack(spacing:0){
                if schedule.items.durationBased{
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 8)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.horizontal, 6)
                } else {
                    Circle()
                        .frame(width: 12)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.horizontal, 4)

                }
                ZStack{
                    //MARK: Background tile
                    RoundedRectangle(cornerRadius: 8)
                                   .foregroundColor(Color(schedule.items.tags.colorName).opacity(0.2))
                    
                    HStack{
                        //MARK: Title
                        Text(schedule.items.titleIcon + " " + schedule.items.title)
                            .foregroundColor(Color("text_black"))
                            .font(.system(size: 15))
                            .padding(.leading, 8)
                        Spacer()
                        
                        //MARK: Score
                        if schedule.statusDefault {
                            Text("\(schedule.score)")
                                .foregroundColor(Color("text_black"))
                                .font(.system(size: 15))
                                .fontWeight(.light)
                                .padding(.trailing, 5)
                        } else {
                            Text("\(schedule.scoreGained) / \(schedule.score)")
                                .foregroundColor(Color("text_black"))
                                .font(.system(size: 12))
                                .fontWeight(.light)
                                .padding(.trailing, 5)
                        }
                    }
                } // End tile center ZStack
                .onTapGesture {
                    changeViewPresented = true
                }
                .sheet(isPresented: $changeViewPresented) {
                    ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, schedule: schedule)
                }
                
                
                
                if schedule.statusDefault{
                    Image(systemName: "flag")
                        .foregroundColor(Color("text_black"))
                        .padding(.leading, 3)
                        .onLongPressGesture {
                            completionViewPresented = true
                        }
                        .sheet(isPresented: $completionViewPresented) {
                            ChangeCompletionView(changeCompletionViewPresented: $completionViewPresented, schedule: schedule)
                        }
                } else {
                    Image(systemName: schedule.checked ? "flag.fill" : "flag")
                        .foregroundColor(Color("text_black"))
                        .padding(.leading, 3)
                        .onLongPressGesture {
                            completionViewPresented = true
                        }
                        .sheet(isPresented: $completionViewPresented) {
                            ChangeCompletionView(changeCompletionViewPresented: $completionViewPresented, schedule: schedule)
                        }
                }
            }
        }        
    }
}

//struct ScheduleTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleTileView()
//    }
//}
