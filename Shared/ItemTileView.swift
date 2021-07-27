//
//  ItemTileView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/25/21.
//

import SwiftUI

struct ItemTileView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    var item:Item
    
    var body: some View {
        ZStack{
            //MARK: Outline in the back
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color(item.tags.colorName),style:StrokeStyle(lineWidth: 1))
                .padding(1)
            //MARK: Inside outline
            //MARK: Left
            HStack(spacing:5){
                if item.durationBased{
                    //MARK: Icon with Rectangular
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(Color(item.tags.colorName).opacity(0.2))
                        Text(item.titleIcon)
                            .font(.system(size: 15))
                    }.frame(width: 40, height: 58)
                    .padding(.leading, 7)
                } else {
                    //MARK: Icon with Circle
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color(item.tags.colorName).opacity(0.2))
                        Text(item.titleIcon)
                            .font(.system(size: 15))
                    }.frame(width: 40, height: 58)
                    .padding(.leading, 7)
                }
                //MARK: Right
                VStack(spacing:5){
                    //MARK: Title
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(Color(item.tags.colorName).opacity(0.2))
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
                }.frame(height:60).padding(.trailing, 7)
            }
        }.frame(height: 72)
    }
}

//struct ItemTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemTileView()
//    }
//}
