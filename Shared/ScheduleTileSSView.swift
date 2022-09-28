//
//  ScheduleTileSSView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/14/21.
//

import SwiftUI

struct ScheduleTileSSView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    var schedule:Schedule
    var showTitle:Bool
    
    let wHandle:CGFloat = 6
    let mHandle:CGFloat = 3
    let fsTitle:CGFloat = 12
    let opTile:Double = 0.15

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color(schedule.items.tags.colorName).opacity(opTile))
            
            HStack(alignment:.center,spacing:2){
                //MARK: Small handle
                if schedule.items.durationBased{
                    RoundedRectangle(cornerRadius: wHandle/2)
                        .frame(width: wHandle)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                } else {
                    Circle()
                        .frame(width: wHandle+2)
                        .foregroundColor(Color(schedule.items.tags.colorName))
                }
                //Title
                Text(showTitle ? schedule.items.titleIcon + schedule.items.title : schedule.items.titleIcon)
                    .foregroundColor(Color("text_black"))
                    .font(.system(size: fsTitle))
                    .fontWeight(.light)
                    
            }
            
        }
    }
}

//struct ScheduleTileSSView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleTileSSView()
//    }
//}
