//
//  autoCompleteModePicker.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/21/21.
//

import SwiftUI

struct autoCompleteModePicker: View {
    @AppStorage("autoCompleteMode") private var autoCompleteMode = 1
    let fsSub:CGFloat = 12
    let rTile:CGFloat = 8
    let rTileOption:CGFloat = 6
    let fsOptions:CGFloat = 14
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Auto recording:")
                .foregroundColor(Color("text_black"))
                .font(.system(size: fsSub))
                .fontWeight(.light)
            ZStack(alignment:.leading){
                Color("tag_color_red").opacity(0.1)
                VStack(alignment: .leading, spacing: 0) {
                    //mode 1
                    ZStack(alignment:.leading){
                        RoundedRectangle(cornerRadius: rTileOption)
                            .foregroundColor(Color("tag_color_red").opacity(autoCompleteMode==0 ? 0.4 : 0))
                            .padding(.horizontal,5)
                        Text("Mark as checked").foregroundColor(Color("text_black"))
                            .font(.system(size: fsOptions)).fontWeight(.light).padding(.horizontal,20).padding(.vertical,5)
                    }
                    .onTapGesture {
                        withAnimation(.default){
                            autoCompleteMode = 0
                        }
                    }
                    
                    // mode 2
                    ZStack(alignment:.leading){
                        RoundedRectangle(cornerRadius: rTileOption)
                            .foregroundColor(Color("tag_color_red").opacity(autoCompleteMode==1 ? 0.4 : 0))
                            .padding(.horizontal,5)
                        Text("Mark as unchecked").foregroundColor(Color("text_black"))
                            .font(.system(size: fsOptions)).fontWeight(.light).padding(.horizontal,20).padding(.vertical,5)
                    }
                    .onTapGesture {
                        withAnimation(.default){
                            autoCompleteMode = 1
                        }
                    }
                    
                    // mode 3
                    ZStack(alignment:.leading){
                        RoundedRectangle(cornerRadius: rTileOption)
                            .foregroundColor(Color("tag_color_red").opacity(autoCompleteMode==3 ? 0.4 : 0))
                            .padding(.horizontal,5)
                        Text("Turn off").foregroundColor(Color("text_black"))
                            .font(.system(size: fsOptions)).fontWeight(.light).padding(.horizontal,20).padding(.vertical,5)
                    }
                    .onTapGesture {
                        withAnimation(.default){
                            autoCompleteMode = 3
                        }
                    }
                    
                }// end 3 mode Vstack
                .padding(.vertical,5)
            }//end tile Zstack
            .clipShape(RoundedRectangle(cornerRadius: rTile))
            if autoCompleteMode == 0{
                Text("The schedules will be marked as completed as the end time is passed")
                .foregroundColor(Color("text_black"))
                .font(.system(size: fsSub))
                .fontWeight(.light)
            } else if autoCompleteMode == 1{
                Text("The schedules will be marked as not completed as the end time is passed")
                .foregroundColor(Color("text_black"))
                .font(.system(size: fsSub))
                .fontWeight(.light)
            } else if autoCompleteMode == 3{
                Text("Auto recored is turned off and you need to manually check the schedule")
                .foregroundColor(Color("text_black"))
                .font(.system(size: fsSub))
                .fontWeight(.light)
            }
        }
    }
}

struct autoCompleteModePicker_Previews: PreviewProvider {
    static var previews: some View {
        autoCompleteModePicker()
    }
}
