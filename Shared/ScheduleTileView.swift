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
    let fsTitle:CGFloat = 16
    let fsSub:CGFloat = 14
    let opSub:Double = 0.5
    let mTime:CGFloat = 20
    let mTimeTop:CGFloat = 9
    let mTimeTile:CGFloat = 2
    let wHandle:CGFloat = 8.5
    let wHandleTight: CGFloat = 6
    let mHandle:CGFloat = 4
    let mHandleTight: CGFloat = 2
    let mHandleLeft:CGFloat = 6
    let mHandleTightLeft:CGFloat = 3
    let rTile:CGFloat = 8
    let opTile0:Double = 0.2
    let opTile:Double = 0.15
    let pTextHor:CGFloat = 8
    let pTextVer:CGFloat = 5
    let pTextHorTight:CGFloat = 5
    let mTileFlag:CGFloat = 5
    let sTileFlag:CGFloat = 18
    
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
                if schedule.id != nil{
                    if schedule.items.durationBased {
                        timeDur
                    } else {
                        timePnt
                    }
                }
            }
            
            //MARK: Tile main body
            HStack(spacing:0){
                //MARK: Small handle
                if schedule.items.durationBased{
                    if schedule.statusDefault {
                        handleDurDefault
                    } else if schedule.checked{
                        handleDurChecked
                    } else {
                        handleDurNotChecked
                    }
                    // end duration-based
                } else {
                    if schedule.statusDefault{
                        handlePntDefault
                        
                    } else if schedule.checked {
                        handlePntChecked
                    } else {
                        handlePntNotChecked
                    }
                }
                
                Button {
                    changeViewPresented = true
                } label: {
                    //MARK: Center tile
//                    ZStack(alignment:.top){
//                        //Background tile
//                        RoundedRectangle(cornerRadius: rTile)
//                            .foregroundColor(Color(schedule.items.tags.colorName).opacity(opTile))
//                        tileText
//                    }
                    tileText
                        .background(LinearGradient(gradient: Gradient(colors: [Color(schedule.items.tags.colorName).opacity(opTile0),
                             Color(schedule.items.tags.colorName).opacity(opTile)]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing),
                                    in: RoundedRectangle(cornerRadius: rTile))
                }//end Button Label
                .sheet(isPresented: $changeViewPresented) {
                    ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, schedule: schedule)
                        .environment(\.managedObjectContext,self.viewContext)
                }
                
                //MARK: Status CheckBox
                VStack{
                    Spacer()
                    if schedule.statusDefault{
                        checkboxDefault
                    } else {
                        checkboxCheckOrUncheck
                    }
                }//end status checkbox Vstack
                
            } // end tile main body HStack
        }
    }
    
    var timeDur: some View{
        Text(DateServer.printShortTime(inputTime: schedule.beginTime) + " - " + DateServer.printShortTime(inputTime: schedule.endTime))
            .foregroundColor(Color("text_black").opacity(opSub))
            .font(.system(size: fsSub))
            .padding(.leading, mTime)
            .padding(.top,mTimeTop)
    }
    
    var timePnt: some View{
        Text(DateServer.printShortTime(inputTime: schedule.beginTime))
            .foregroundColor(Color("text_black").opacity(opSub))
            .font(.system(size: fsSub))
            .padding(.leading, mTime)
            .padding(.top,mTimeTop)
    }
    
    var handleDurDefault: some View{
        ZStack{
            RoundedRectangle(cornerRadius: wHandle/2)
                .frame(width: showTitle ? wHandle : wHandleTight)
                .foregroundColor(Color("background_white"))
                .padding(.trailing, showTitle ? mHandle : mHandleTight)
                .padding(.leading, showTitle ? mHandleLeft : 0)
            
            RoundedRectangle(cornerRadius: wHandle/2)
                .frame(width: showTitle ? wHandle : wHandleTight)
                .foregroundColor(Color(schedule.items.tags.colorName).opacity(0.1))
                .padding(.trailing, showTitle ? mHandle : mHandleTight)
                .padding(.leading, showTitle ? mHandleLeft : 0)
            
            RoundedRectangle(cornerRadius: wHandle/2)
                .stroke(Color(schedule.items.tags.colorName),lineWidth: 1.5)
                .frame(width: showTitle ? wHandle : wHandleTight)
                .padding(.trailing, showTitle ? mHandle : mHandleTight)
                .padding(.leading, showTitle ? mHandleLeft : 0)
            
        }
    }
    
    var handleDurChecked: some View {
        RoundedRectangle(cornerRadius: wHandle/2)
            .frame(width: showTitle ? wHandle : wHandleTight)
            .foregroundColor(Color(schedule.items.tags.colorName))
            .padding(.trailing, showTitle ? mHandle : mHandleTight)
            .padding(.leading, showTitle ? mHandleLeft : 0)
    }
    
    var handleDurNotChecked: some View{
        ZStack{
            RoundedRectangle(cornerRadius: wHandle/2)
                .frame(width: showTitle ? wHandle : wHandleTight)
                .foregroundColor(Color("background_white"))
                .padding(.trailing, showTitle ? mHandle : mHandleTight)
                .padding(.leading, showTitle ? mHandleLeft : 0)
            
            RoundedRectangle(cornerRadius: wHandle/2)
                .stroke(Color(schedule.items.tags.colorName),lineWidth: 1.5)
                .frame(width: showTitle ? wHandle : wHandleTight)
                .padding(.trailing, showTitle ? mHandle : mHandleTight)
                .padding(.leading, showTitle ? mHandleLeft : 0)
        }
    }
    
    var handlePntDefault: some View{
        ZStack{
            Circle()
                .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
                .foregroundColor(Color("background_white"))
                .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
                .padding(.leading, showTitle ? mHandleLeft - 2 : 0)
            Circle()
                .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
                .foregroundColor(Color(schedule.items.tags.colorName).opacity(0.1))
                .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
                .padding(.leading, showTitle ? mHandleLeft - 2 : 0)
            Circle()
                .stroke(Color(schedule.items.tags.colorName),lineWidth: 1.5)
                .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
                .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
                .padding(.leading, showTitle ? mHandleLeft - 2 : 0)
        }
    }
    
    var handlePntChecked: some View{
        Circle()
            .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
            .foregroundColor(Color(schedule.items.tags.colorName))
            .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
            .padding(.leading, showTitle ? mHandleLeft - 2 : 0)
    }
    
    var handlePntNotChecked: some View{
        ZStack{
            Circle()
                .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
                .foregroundColor(Color("background_white"))
                .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
                .padding(.leading, showTitle ? mHandleLeft - 2 : 0)
            Circle()
                .stroke(Color(schedule.items.tags.colorName),lineWidth: 1.5)
                .frame(width: showTitle ? wHandle + 4 : wHandleTight + 2)
                .padding(.trailing, showTitle ? mHandle - 2 : mHandleTight - 1 )
                .padding(.leading, showTitle ? mHandleLeft - 2 : 0)
        }
    }
    
    var tileText: some View {
        HStack{
            //Title
            VStack{
                Text(showTitle ? schedule.items.titleIcon + " " + schedule.items.title : schedule.items.titleIcon)
                    .foregroundColor(Color(schedule.items.tags.colorName+"_text"))
                    .font(.system(size: fsTitle))
                    //.fontWeight(.semibold)
                    .padding(.leading, pTextHor)
                    .padding(.top,pTextVer)
                Spacer()
            }
            
            Spacer()
            
            //Score
            if schedule.score>0 {
                VStack{
                    Spacer()
                    if schedule.statusDefault {
                        Text("? / \(schedule.score)")
                            .foregroundColor(Color(schedule.items.tags.colorName+"_text"))
                            .font(.system(size: fsSub))
                            .padding(.trailing, pTextHorTight)
                            .padding(.bottom, pTextVer)
                    } else {
                        Text("\(schedule.scoreGained) / \(schedule.score)")
                            .foregroundColor(Color(schedule.items.tags.colorName+"_text"))
                            .font(.system(size: fsSub))
                            .padding(.trailing, pTextHorTight)
                            .padding(.bottom, pTextVer)
                    }
                }//end score VStack
            }
        }
    }
    
    var checkboxDefault:some View{
        Image(systemName: "square")
            .resizable().scaledToFit()
            .foregroundColor(Color(schedule.items.tags.colorName).opacity(1))
            .shadow(color: Color("text_black").opacity(0.2),
                    radius: 2, x:2, y:2)
            .frame(width: sTileFlag,height: sTileFlag)
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
    }
    
    var checkboxCheckOrUncheck:some View{
        Image(systemName: schedule.checked ? "checkmark.square" : "square")
            .resizable().scaledToFit()
            .foregroundColor(Color(schedule.items.tags.colorName))
            .shadow(color: Color("text_black").opacity(0.2),
                    radius: 2, x:2, y:2)
            .frame(width: sTileFlag,height: sTileFlag)
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
}

//struct ScheduleTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleTileView()
//    }
//}
