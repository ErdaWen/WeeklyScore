//
//  ScheduleTileView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/29/21.
//

import SwiftUI

struct ScheduleTileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    var schedule:Schedule
    var showTime:Bool
    var showTitle:Bool
    
    @State var completionViewPresented = false
    @State var changeViewPresented = false
    
    // appearacne related
    let fsTitle:CGFloat = 15
    let fsSub:CGFloat = 12.0
    let opSub:Double = 0.5
    let mTime:CGFloat = 20
    let mTimeTile:CGFloat = 3
    let wHandle:CGFloat = 8
    let wHandleTight: CGFloat = 6
    let mHandle:CGFloat = 6
    let mHandleTight: CGFloat = 3
    let rTile:CGFloat = 8
    let opTile:Double = 0.15
    let pTextHor:CGFloat = 8
    let pTextVer:CGFloat = 5
    let pTextHorTight:CGFloat = 5
    let mTileFlag:CGFloat = 3
    
    func saveSchedule(inputChecked:Bool, inputScoreGained:Int64, inputMinutesGained:Int64) {
        // Calculate check changed
        var checkChanged:Int64 = 0
        
        if schedule.checked != inputChecked{
            checkChanged = inputChecked ? 1 : -1
        }
        
        // Execute change to habit for records
        schedule.items.checkedTotal += checkChanged
        schedule.items.scoreTotal += inputScoreGained - schedule.scoreGained
        schedule.items.minutesTotal += inputMinutesGained - schedule.minutesGained
        
        // Execute change to entry
        schedule.scoreGained = inputScoreGained
        schedule.minutesGained = inputMinutesGained
        schedule.checked = inputChecked
        schedule.statusDefault = false
                
        do{
            try viewContext.save()
            print("saved")
            propertiesModel.updateScores()
            propertiesModel.dumUpdate.toggle()
        } catch {
            print("Cannot save item")
            print(error)
        }
    }
    
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
                    if schedule.statusDefault {
                        ZStack{
                            RoundedRectangle(cornerRadius: wHandle/2)
                                .frame(width: showTitle ? wHandle : wHandleTight)
                                .foregroundColor(Color("background_white"))
                                .padding(.trailing, showTitle ? mHandle : mHandleTight)
                                .padding(.leading, showTitle ? mHandle : 0)
                            
                            RoundedRectangle(cornerRadius: wHandle/2)
                                .frame(width: showTitle ? wHandle : wHandleTight)
                                .foregroundColor(Color(schedule.items.tags.colorName).opacity(0.1))
                                .padding(.trailing, showTitle ? mHandle : mHandleTight)
                                .padding(.leading, showTitle ? mHandle : 0)

                            RoundedRectangle(cornerRadius: wHandle/2)
                                .stroke(Color(schedule.items.tags.colorName),lineWidth: 1.5)
                                .frame(width: showTitle ? wHandle : wHandleTight)
                                .padding(.trailing, showTitle ? mHandle : mHandleTight)
                                .padding(.leading, showTitle ? mHandle : 0)

                        }
                    } else if schedule.checked{
                    RoundedRectangle(cornerRadius: wHandle/2)
                        .frame(width: showTitle ? wHandle : wHandleTight)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.trailing, showTitle ? mHandle : mHandleTight)
                        .padding(.leading, showTitle ? mHandle : 0)
                        
                    } else {
                        ZStack{
                            RoundedRectangle(cornerRadius: wHandle/2)
                                .frame(width: showTitle ? wHandle : wHandleTight)
                                .foregroundColor(Color("background_white"))
                                .padding(.trailing, showTitle ? mHandle : mHandleTight)
                                .padding(.leading, showTitle ? mHandle : 0)

                            RoundedRectangle(cornerRadius: wHandle/2)
                                .stroke(Color(schedule.items.tags.colorName),lineWidth: 1.5)
                                .frame(width: showTitle ? wHandle : wHandleTight)
                                .padding(.trailing, showTitle ? mHandle : mHandleTight)
                                .padding(.leading, showTitle ? mHandle : 0)
                            
                        }
                        

                    }
                    // end duration-based
                } else {
                    if schedule.statusDefault{
                        ZStack{
                            Circle()
                                .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
                                .foregroundColor(Color("background_white"))
                                .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
                                .padding(.leading, showTitle ? mHandle - 2 : 0)
                            Circle()
                                .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
                                .foregroundColor(Color(schedule.items.tags.colorName).opacity(0.1))
                                .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
                                .padding(.leading, showTitle ? mHandle - 2 : 0)
                            Circle()
                                .stroke(Color(schedule.items.tags.colorName),lineWidth: 1.5)
                                .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
                                .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
                                .padding(.leading, showTitle ? mHandle - 2 : 0)

                        }
                        
                    } else if schedule.checked {
                    Circle()
                        .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
                        .padding(.leading, showTitle ? mHandle - 2 : 0)
                    } else {
                        ZStack{
                            Circle()
                                .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
                                .foregroundColor(Color("background_white"))
                                .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
                                .padding(.leading, showTitle ? mHandle - 2 : 0)
                            Circle()
                                .stroke(Color(schedule.items.tags.colorName),lineWidth: 1.5)
                                .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
                                .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
                                .padding(.leading, showTitle ? mHandle - 2 : 0)
                        }
                        
                    }

                }
                
                Button {
                        changeViewPresented = true
                } label: {
                    //MARK: Center tile
                    ZStack(alignment:.top){
                        //MARK: Background tile
                        RoundedRectangle(cornerRadius: rTile).foregroundColor(Color(schedule.items.tags.colorName).opacity(opTile))
                        
                        HStack{
                            //MARK: Title
                            VStack{
                                Text(showTitle ? schedule.items.titleIcon + " " + schedule.items.title : schedule.items.titleIcon)
                                    .foregroundColor(Color(schedule.items.tags.colorName+"_text"))
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
                                    Text("? / \(schedule.score)")
                                        .foregroundColor(Color(schedule.items.tags.colorName+"_text"))
                                        .font(.system(size: fsSub)).fontWeight(.light)
                                        .padding(.trailing, pTextHorTight)
                                        .padding(.bottom, pTextVer)
                                } else {
                                    Text("\(schedule.scoreGained) / \(schedule.score)")
                                        .foregroundColor(Color(schedule.items.tags.colorName+"_text"))
                                        .font(.system(size: fsSub))
                                        .fontWeight(.light)
                                        .padding(.trailing, pTextHorTight)
                                        .padding(.bottom, pTextVer)
                                }
                            }//end score VStack
                            
                        }
                    } // End center tile ZStack

                }//end Button Label
                .sheet(isPresented: $changeViewPresented) {
                    ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, schedule: schedule)
                        .environment(\.managedObjectContext,self.viewContext)
                }
                
                //MARK: Status CheckBox
                VStack{
                    Spacer()
                    if schedule.statusDefault{
                        Image(systemName: "flag")
                            .foregroundColor(Color(schedule.items.tags.colorName).opacity(0.3))
                            .padding(.leading, mTileFlag)
                            .padding(.bottom, pTextVer)
                            .onTapGesture {
                                let totMin = DateServer.getTotMin(beginTime: schedule.beginTime, endTime: schedule.endTime)
                                saveSchedule(inputChecked: true, inputScoreGained: schedule.score, inputMinutesGained: totMin)
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                            }
//                            .onLongPressGesture {
//                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
//                                    impactMed.impactOccurred()
//                                completionViewPresented = true
//                            }
                            .sheet(isPresented: $completionViewPresented) {
                                ChangeCompletionView(changeCompletionViewPresented: $completionViewPresented, schedule: schedule)
                            }
                    } else {
                        Image(systemName: schedule.checked ? "flag.fill" : "flag")
                            .foregroundColor(Color(schedule.items.tags.colorName))
                            .padding(.leading, mTileFlag)
                            .padding(.bottom, pTextVer)
                            .onTapGesture {
                                let totMin = DateServer.getTotMin(beginTime: schedule.beginTime, endTime: schedule.endTime)
                                saveSchedule(inputChecked: schedule.checked ? false : true, inputScoreGained: schedule.checked ? 0: schedule.score, inputMinutesGained: schedule.checked ? 0: totMin)
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                            }
//                            .onLongPressGesture {
//                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
//                                    impactMed.impactOccurred()
//                                completionViewPresented = true
//                            }
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
