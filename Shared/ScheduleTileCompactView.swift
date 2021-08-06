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


    
    var body: some View {
        Button {
            changeViewPresented = true
        } label: {
            //MARK: Center tile
            ZStack(alignment:.center){
                //MARK: Background tile
                RoundedRectangle(cornerRadius: rTile).foregroundColor(Color(schedule.items.tags.colorName).opacity(opTile))
                    Text(schedule.items.titleIcon)
                        .font(.system(size: fsTitle))
                
            } // End center tile ZStack
        }//end Button Label
        .sheet(isPresented: $changeViewPresented) {
            ChangeScheduleView(changeScheduleViewPresented: $changeViewPresented, schedule: schedule)
        }
        
        
    }
}

//struct ScheduleTileCompact_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleTileCompactView()
//    }
//}
