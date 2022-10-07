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
    let wHandle:CGFloat = 7
    let mHandle:CGFloat = 1
    let pTextVer:CGFloat = 3
    let rShadow:CGFloat = 3
    let opShadow = 0.2
    
    var body: some View {
        HStack(spacing:0){
            if schedule.items.durationBased{
                if schedule.statusDefault{
                    ZStack{
                        RoundedRectangle(cornerRadius: wHandle/2)
                            .frame(width: wHandle)
                            .foregroundColor(Color("background_white"))
                            .padding(.trailing, mHandle)
                            .padding(.leading, 1)
                        RoundedRectangle(cornerRadius: wHandle/2)
                            .frame(width: wHandle)
                            .foregroundColor(Color(schedule.items.tags.colorName).opacity(0.1))
                            .padding(.trailing, mHandle)
                            .padding(.leading, 1)
                            .shadow(color: Color("text_black").opacity(opShadow),
                                    radius: rShadow, x:0, y:0)
                        RoundedRectangle(cornerRadius: wHandle/2)
                            .stroke(Color(schedule.items.tags.colorName),lineWidth: 1)
                            .frame(width: wHandle)
                            .padding(.trailing, mHandle)
                            .padding(.leading, 1)
                    }

                } else if schedule.checked{
                    RoundedRectangle(cornerRadius: wHandle/2)
                        .frame(width: wHandle)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.trailing, mHandle)
                        .padding(.leading, 1)
                        .shadow(color: Color("text_black").opacity(opShadow),
                                radius: rShadow, x:0, y:0)

                } else {
                    ZStack{
                        RoundedRectangle(cornerRadius: wHandle/2)
                            .frame(width: wHandle)
                            .foregroundColor(Color("background_white"))
                            .padding(.trailing, mHandle)
                            .padding(.leading, 1)
                            .shadow(color: Color("text_black").opacity(opShadow),
                                    radius: rShadow, x:0, y:0)

                        RoundedRectangle(cornerRadius: wHandle/2)
                            .stroke(Color(schedule.items.tags.colorName),lineWidth: 1)
                            .frame(width: wHandle)
                            .padding(.trailing, mHandle)
                            .padding(.leading, 1)

                    }
                    
                }
                // end duration-based
            } else {
                if schedule.statusDefault{
                    ZStack{
                        Circle()
                            .frame(width: wHandle+2)
                            .foregroundColor(Color("background_white"))
                            .padding(.trailing, mHandle-1)
                        Circle()
                            .foregroundColor(Color(schedule.items.tags.colorName).opacity(1))
                            .frame(width: wHandle+2)
                            .padding(.trailing, mHandle-1)
                            .shadow(color: Color("text_black").opacity(opShadow),
                                    radius: rShadow, x:0, y:0)
                        Circle()
                            .stroke(Color(schedule.items.tags.colorName),lineWidth: 1)
                            .frame(width: wHandle+2)
                            .padding(.trailing, mHandle-1)
                    }
                    
                } else if schedule.checked{
                    Circle()
                        .frame(width: wHandle+2)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                        .padding(.trailing, mHandle-1)
                        .shadow(color: Color("text_black").opacity(opShadow),
                                radius: rShadow, x:0, y:0)
                } else {
                    ZStack{
                        Circle()
                            .frame(width: wHandle+2)
                            .foregroundColor(Color("background_white"))
                            .padding(.trailing, mHandle-1)
                            .shadow(color: Color("text_black").opacity(opShadow),
                                    radius: rShadow, x:0, y:0)
                        Circle()
                            .stroke(Color(schedule.items.tags.colorName),lineWidth: 1)
                            .frame(width: wHandle+2)
                            .padding(.trailing, mHandle-1)

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
                        .shadow(color: Color("text_black").opacity(opShadow),
                                radius: rShadow, x:0, y:0)
                    Text(schedule.items.titleIcon)
                        .font(.system(size: fsTitle))
                        .padding(.top,pTextVer)
                    
                } // End center tile ZStack
            }//end Button Label
            .sheet(isPresented: $changeViewPresented) {
                ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, schedule: schedule)
                    .environment(\.managedObjectContext,self.viewContext)
            }
            
        }
    }
}

//struct ScheduleTileCompact_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleTileCompactView()
//    }
//}
