//
//  ItemTileView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/25/21.
//

import SwiftUI

struct ItemTileView: View {
    
    var item:Item
    
    var body: some View {
        ZStack{
            //MARK: Outline in the back
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(item.tags.colorName),style:StrokeStyle(lineWidth: 1))
            //MARK: Inside outline
            //MARK: Left
            HStack(spacing:5){
                if item.durationBased{
                    //MARK: Icon with Rectangular
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(Color(item.tags.colorName).opacity(0.3))
                        Text(item.titleIcon)
                            .font(.system(size: 20))
                    }.frame(width: 45, height: 60)
                    .padding(.leading, 8)
                } else {
                    //MARK: Icon with Circle
                    ZStack{
                        Circle()
                            .foregroundColor(Color(item.tags.colorName).opacity(0.3))
                        Text(item.titleIcon)
                            .font(.system(size: 30))
                    }.frame(width: 45, height: 60)
                    .padding(.leading, 8)
                }
                //MARK: Right
                VStack(spacing:5){
                    //MARK: Title
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(Color(item.tags.colorName).opacity(0.3))
                        Text(item.title)
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .foregroundColor(Color("text_black"))
                    }.frame(height: 23)
                    //MARK: Statistics
                    HStack{
                        //MARK:Time/Hit
                        Spacer()
                        VStack{
                            Text(item.durationBased ? "Total Time" : "Total Hits")
                                .font(.system(size: 10))
                                .fontWeight(.light)
                                .foregroundColor(Color("text_black"))
                            Text(item.durationBased ? String(item.minutesTotal) : String(item.checkedTotal))
                                .font(.system(size: 15))
                                .fontWeight(.light)
                                .foregroundColor(Color("text_black"))
                        }
                        //MARK: Scores
                        Spacer()
                        VStack{
                            Text("Total Scores")
                                .font(.system(size: 10))
                                .fontWeight(.light)
                                .foregroundColor(Color("text_black"))
                            Text(String(item.scoreTotal))
                                .font(.system(size: 15))
                                .fontWeight(.light)
                                .foregroundColor(Color("text_black"))
                            
                        }
                        Spacer()
                    }
                }.frame(height:60).padding(.init(.init(top: 5, leading: 0, bottom: 5, trailing: 8)))
            }
        }.frame(height: 70)
    }
}

//struct ItemTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemTileView()
//    }
//}
