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
    var showTime:Bool
    
    @State var completionViewPresented = false
    @State var changeViewPresented = false
    
    // appearacne related
    let fsTitle:CGFloat = 15
    let fsSub:CGFloat = 12.0
    let opSub:Double = 0.5
    let mTime:CGFloat = 20
    let mTimeTile:CGFloat = 3
    let wHandle:CGFloat = 8
    let mHandle:CGFloat = 6
    let rTile:CGFloat = 8
    let opTile:Double = 0.2
    let pTextHor:CGFloat = 8
    let pTextVer:CGFloat = 5
    let pTextHorTight:CGFloat = 5
    let mTileFlag:CGFloat = 3
    
    var body: some View {
        VStack(alignment: .leading, spacing: mTimeTile) {
            
            //MARK: Time title
            if showTime{
                // A buildtime bug: when deleting the Schedule object, fetched schedule may not refresh properly
                if schedule.id != nil{
                    if schedule.items.durationBased {
                        Text(DateServer.printShortTime(inputTime: schedule.beginTime) + " - " + DateServer.printShortTime(inputTime: schedule.endTime))
                            .foregroundColor(Color("text_black").opacity(opSub)).font(.system(size: fsSub)).padding(.leading, mTime)
                    } else {
                        Text(DateServer.printShortTime(inputTime: schedule.beginTime))
                            .foregroundColor(Color("text_black").opacity(opSub)).font(.system(size: fsSub)).padding(.leading, mTime)
                    }
                }
            }

            //MARK: Tile main body
            HStack(spacing:0){
                //MARK: Small handle
                if schedule.items.durationBased{
                    RoundedRectangle(cornerRadius: wHandle/2)
                        .frame(width: wHandle)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.horizontal, mHandle)
                } else {
                    Circle()
                        .frame(width: wHandle+4)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.horizontal, mHandle-2)

                }
                //MARK: Center tile
                ZStack(alignment:.top){
                    //MARK: Background tile
                    RoundedRectangle(cornerRadius: rTile).foregroundColor(Color(schedule.items.tags.colorName).opacity(opTile))
                    
                    HStack{
                        //MARK: Title
                        VStack{
                            Text(schedule.items.titleIcon + " " + schedule.items.title)
                            .foregroundColor(Color("text_black"))
                            .font(.system(size: fsTitle))
                            .padding(.leading, pTextHor)
                            .padding(.top,pTextVer)
                            Spacer()
                        }

                        Spacer()
                        
                        //MARK: Score
                        VStack{
                            Spacer()
                            if schedule.statusDefault {
                                Text("\(schedule.score)")
                                    .foregroundColor(Color("text_black"))
                                    .font(.system(size: fsSub)).fontWeight(.light)
                                    .padding(.trailing, pTextHorTight)
                                    .padding(.bottom, pTextVer)
                            } else {
                                Text("\(schedule.scoreGained) / \(schedule.score)")
                                    .foregroundColor(Color("text_black"))
                                    .font(.system(size: fsSub))
                                    .fontWeight(.light)
                                    .padding(.trailing, pTextHorTight)
                                    .padding(.bottom, pTextVer)
                            }
                        }//end score VStack
                        
                    }
                } // End center tile ZStack
                .onTapGesture {
                    changeViewPresented = true
                }
                .sheet(isPresented: $changeViewPresented) {
                    ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, schedule: schedule)
                }
                
                //MARK: Status CheckBox
                VStack{
                    Spacer()
                    if schedule.statusDefault{
                        Image(systemName: "flag")
                            .foregroundColor(Color("text_black"))
                            .padding(.leading, mTileFlag)
                            .padding(.bottom, pTextVer)
                            .onLongPressGesture {
                                completionViewPresented = true
                            }
                            .sheet(isPresented: $completionViewPresented) {
                                ChangeCompletionView(changeCompletionViewPresented: $completionViewPresented, schedule: schedule)
                            }
                    } else {
                        Image(systemName: schedule.checked ? "flag.fill" : "flag")
                            .foregroundColor(Color("text_black"))
                            .padding(.leading, mTileFlag)
                            .padding(.bottom, pTextVer)
                            .onLongPressGesture {
                                completionViewPresented = true
                            }
                            .sheet(isPresented: $completionViewPresented) {
                                ChangeCompletionView(changeCompletionViewPresented: $completionViewPresented, schedule: schedule)
                            }
                    }
                }//end status checkbox Vstack

            } // end tile main body HStack
        }        
    }
}

//struct ScheduleTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleTileView()
//    }
//}
