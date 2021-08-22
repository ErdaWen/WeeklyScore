//
//  nightModePicker.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/21/21.
//

import SwiftUI

struct nightModePicker: View {
    @AppStorage("nightMode") private var nightMode = true
    
    let fsSub:CGFloat = 12
    let rTile:CGFloat = 8
    let rTileOption:CGFloat = 6
    let fsOptions:CGFloat = 14
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Night mode:")
                .foregroundColor(Color("text_black"))
                .font(.system(size: fsSub))
                .fontWeight(.light)
            ZStack(alignment:.leading){
                Color("tag_color_yellow").opacity(0.1)
                VStack(alignment: .leading, spacing: 0) {
                    
                        ZStack(alignment:.leading){
                            RoundedRectangle(cornerRadius: rTileOption)
                                .foregroundColor(Color("tag_color_yellow").opacity(nightMode ? 0.4 : 0))
                                .padding(.horizontal,5)
                            Text("Automatic").foregroundColor(Color("text_black"))
                                .font(.system(size: fsOptions)).fontWeight(.light).padding(.horizontal,20).padding(.vertical,5)
                        }
                        .onTapGesture {
                            withAnimation(.default){
                                nightMode = true
                            }
                        }
                    
                    
                    ZStack(alignment:.leading){
                        RoundedRectangle(cornerRadius: rTileOption)
                            .foregroundColor(Color("tag_color_yellow").opacity(!nightMode ? 0.4 : 0))
                            .padding(.horizontal,5)
                        Text("Always light mode").foregroundColor(Color("text_black"))
                            .font(.system(size: fsOptions)).fontWeight(.light).padding(.horizontal,20).padding(.vertical,5)
                    }
                    .onTapGesture {
                        withAnimation(.default){
                            nightMode = false
                        }
                    }

                    
                }// end 2 options Vstack
                .padding(.vertical,5)
            }//end tile Zstack
            .clipShape(RoundedRectangle(cornerRadius: rTile))
        }
    }
}

struct nightModePicker_Previews: PreviewProvider {
    static var previews: some View {
        nightModePicker()
    }
}
