//
//  ScheduleTileCompact.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/5/21.
//

import SwiftUI

struct ScheduleTileCompactView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    var schedule:Schedule
    
    @State var completionViewPresented = false
    @State var changeViewPresented = false
    
    // appearacne related
    let fsTitle:CGFloat = 15
    let rTile:CGFloat = 8
    let opTile:Double = 0.15
    let wHandle:CGFloat = 6
    let mHandle:CGFloat = 3
    let pTextVer:CGFloat = 3
    
    var body: some View {
        HStack(spacing:0){
            if schedule.items.durationBased{
                if schedule.statusDefault{
                    ZStack{
                        RoundedRectangle(cornerRadius: wHandle/2)
                            .frame(width: wHandle)
                            .foregroundColor(Color("background_white"))
                            .padding(.trailing, mHandle)
                        RoundedRectangle(cornerRadius: wHandle/2)
                            .frame(width: wHandle)
                            .foregroundColor(Color(schedule.items.tags.colorName).opacity(0.1))
                            .padding(.trailing, mHandle)
                        RoundedRectangle(cornerRadius: wHandle/2)
                            .stroke(Color(schedule.items.tags.colorName),lineWidth: 1)
                            .frame(width: wHandle)
                            .padding(.trailing, mHandle)
                    }
                } else if schedule.checked{
                    RoundedRectangle(cornerRadius: wHandle/2)
                        .frame(width: wHandle)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.trailing, mHandle)
                } else {
                    ZStack{
                        RoundedRectangle(cornerRadius: wHandle/2)
                            .frame(width: wHandle)
                            .foregroundColor(Color("background_white"))
                            .padding(.trailing, mHandle)
                        RoundedRectangle(cornerRadius: wHandle/2)
                            .stroke(Color(schedule.items.tags.colorName),lineWidth: 1)
                            .frame(width: wHandle)
                            .padding(.trailing, mHandle)
                    }
                }
                // end duration-based
            } else {
                if schedule.statusDefault{
                    ZStack{
                        Circle()
                            .frame(width: wHandle+2)
                            .foregroundColor(Color("background_white"))
                            .padding(.trailing, mHandle-2)
                        Circle()
                            .foregroundColor(Color(schedule.items.tags.colorName).opacity(0.1))
                            .frame(width: wHandle+2)
                            .padding(.trailing, mHandle-2)
                        Circle()
                            .stroke(Color(schedule.items.tags.colorName),lineWidth: 1)
                            .frame(width: wHandle+2)
                            .padding(.trailing, mHandle-2)
                    }
                } else if schedule.checked{
                    Circle()
                        .frame(width: wHandle+2)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.trailing, mHandle-2)
                } else {
                    ZStack{
                        Circle()
                            .frame(width: wHandle+2)
                            .foregroundColor(Color("white"))
                            .padding(.trailing, mHandle-2)
                        Circle()
                            .stroke(Color(schedule.items.tags.colorName),lineWidth: 1)
                            .frame(width: wHandle+2)
                            .padding(.trailing, mHandle-2)
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
                    Text(schedule.items.titleIcon)
                        .font(.system(size: fsTitle))
                        .padding(.top,pTextVer)
                    
                } // End center tile ZStack
            }//end Button Label
            .sheet(isPresented: $changeViewPresented) {
                ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, schedule: schedule)
            }
            
        }
    }
}

//struct ScheduleTileCompact_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleTileCompactView()
//    }
//}
