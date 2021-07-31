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
            
            //MARK: Time Title
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
            
            //MAKR: Tile itself
            HStack(spacing:0){
                //MARK: Small handle
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
                //MARK: Center tile
                ZStack(alignment:.top){
                    //MARK: Background tile
                    RoundedRectangle(cornerRadius: 8)
                                   .foregroundColor(Color(schedule.items.tags.colorName).opacity(0.1))
                    
                    HStack{
                        //MARK: Title
                        Text(schedule.items.titleIcon + " " + schedule.items.title)
                            .foregroundColor(Color("text_black"))
                            .font(.system(size: 15))
                            .padding(.leading, 8)
                            .padding(.top,1)
                        Spacer()
                        
                        //MARK: Score
                        VStack{
                            Spacer()
                            if schedule.statusDefault {
                                Text("\(schedule.score)")
                                    .foregroundColor(Color("text_black"))
                                    .font(.system(size: 12))
                                    .fontWeight(.light)
                                    .padding(.trailing, 5)
                                    .padding(.bottom, 5)
                            } else {
                                Text("\(schedule.scoreGained) / \(schedule.score)")
                                    .foregroundColor(Color("text_black"))
                                    .font(.system(size: 12))
                                    .fontWeight(.light)
                                    .padding(.trailing, 5)
                                    .padding(.bottom, 5)
                            }
                        }//end score VStack
                        
                    }
                } // End tile center ZStack
                .onTapGesture {
                    changeViewPresented = true
                }
                .sheet(isPresented: $changeViewPresented) {
                    ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, schedule: schedule)
                }
                
                // Change Status Icon
                VStack{
                    Spacer()
                    if schedule.statusDefault{
                        Image(systemName: "flag")
                            .foregroundColor(Color("text_black"))
                            .padding(.leading, 3)
                            .padding(.bottom, 5)
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
                            .padding(.bottom, 5)
                            .onLongPressGesture {
                                completionViewPresented = true
                            }
                            .sheet(isPresented: $completionViewPresented) {
                                ChangeCompletionView(changeCompletionViewPresented: $completionViewPresented, schedule: schedule)
                            }
                    }
                }//end change status Vstack

            }
        }        
    }
}

//struct ScheduleTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleTileView()
//    }
//}
