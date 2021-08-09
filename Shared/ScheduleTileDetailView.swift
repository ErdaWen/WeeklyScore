//
//  ScheduleTileDetailView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/8/21.
//

import SwiftUI

struct ScheduleTileDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    @State var completionViewPresented = false
    
    
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
    
    var schedule:Schedule
    
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
        
        VStack{
            //MARK: Begin Time
            if schedule.id != nil{
        
                    Text(DateServer.printShortTime(inputTime: schedule.beginTime) + DateServer.describeDay(date: schedule.beginTime).0)
                        .foregroundColor(Color("text_black").opacity(opSub)).font(.system(size: fsSub)).padding(.leading, mTime)

            }
            
            HStack(spacing:0){
                //MARK: Small handle
                if schedule.items.durationBased{
                    RoundedRectangle(cornerRadius: wHandle/2)
                        .frame(width:  wHandle )
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.trailing, mHandle)
                        .padding(.leading, mHandle)
                } else {
                    Circle()
                        .frame(width: wHandle + 4)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.trailing, mHandle )
                        .padding(.leading, mHandle - 2)

                }
                //MARK: Center tile
                ZStack(alignment:.bottomTrailing){
                    //MARK: Background tile
                    RoundedRectangle(cornerRadius: rTile).foregroundColor(Color(schedule.items.tags.colorName).opacity(opTile))
                    
                    //MARK: Title
                    VStack(alignment:.center){
                        Spacer()
                        Text(schedule.items.titleIcon + " " + schedule.items.title)
                            .foregroundColor(Color(schedule.items.tags.colorName+"_text"))
                        .font(.system(size: fsTitle))
                        .padding(.leading, pTextHor)
                        .padding(.top,pTextVer)
                        Spacer()
                    }
                    
                    VStack(alignment:.trailing){
                        Spacer()
                        
                        if schedule.items.durationBased{
                            if schedule.statusDefault {
                                Text("? / \(DateServer.getTotMin(beginTime: schedule.beginTime, endTime: schedule.endTime)) min")
                                    .foregroundColor(Color("text_black"))
                                    .font(.system(size: fsSub)).fontWeight(.light)
                                    .padding(.trailing, pTextHorTight)
                                    .padding(.bottom, pTextVer)
                            } else {
                                Text("\(schedule.minutesGained) / \(DateServer.getTotMin(beginTime: schedule.beginTime, endTime: schedule.endTime)) min")
                                    .foregroundColor(Color("text_black"))
                                    .font(.system(size: fsSub)).fontWeight(.light)
                                    .padding(.trailing, pTextHorTight)
                                    .padding(.bottom, pTextVer)
                            }
                        }
                        
                        if schedule.statusDefault {
                            Text("? / \(schedule.score)")
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
                    }//end tot min + score VStack
                }// end center tile ZStack
                
                //MARK: Status CheckBox
                VStack{
                    Spacer()
                    if schedule.statusDefault{
                        Image(systemName: "flag")
                            .foregroundColor(Color("text_black"))
                            .padding(.leading, mTileFlag)
                            .padding(.bottom, pTextVer)
                            .onTapGesture {
                                let totMin = DateServer.getTotMin(beginTime: schedule.beginTime, endTime: schedule.endTime)
                                saveSchedule(inputChecked: true, inputScoreGained: schedule.score, inputMinutesGained: totMin)
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                            }
                            .onLongPressGesture {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
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
                            .onTapGesture {
                                let totMin = DateServer.getTotMin(beginTime: schedule.beginTime, endTime: schedule.endTime)
                                saveSchedule(inputChecked: schedule.checked ? false : true, inputScoreGained: schedule.checked ? 0: schedule.score, inputMinutesGained: schedule.checked ? 0: totMin)
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                            }
                            .onLongPressGesture {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                completionViewPresented = true
                            }
                            .sheet(isPresented: $completionViewPresented) {
                                ChangeCompletionView(changeCompletionViewPresented: $completionViewPresented, schedule: schedule)
                            }
                    }
                }//end status checkbox Vstack
                
            }// end whole H stack
            
            // MARK: End time
            Text(DateServer.printShortTime(inputTime: schedule.endTime) + DateServer.describeDay(date: schedule.endTime).0)
                .foregroundColor(Color("text_black").opacity(opSub)).font(.system(size: fsSub)).padding(.leading, mTime)
            
        }
        
       
    }
}

//struct ScheduleTileDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleTileDetailView()
//    }
//}
