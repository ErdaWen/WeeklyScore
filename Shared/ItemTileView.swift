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
    var dumUpdate:Bool
    @State var changeViewPresented = false
    
    let fsTitle:CGFloat = 15
    let fsSub:CGFloat = 15
    let wHandle:CGFloat = 8
    let mHandle:CGFloat = 8
    let rTile:CGFloat = 10
    let rSmallTile:CGFloat = 8
    let mSmallTiles:CGFloat = 18
    let mSmallTileVer:CGFloat = 10
    let opTile:Double = 0.15
    let pTextVer:CGFloat = 8
    let mTextVer:CGFloat = 0
    let pTextHorTight:CGFloat = 5
    
    var body: some View {
        
        // MARK: Design1
        HStack(spacing:0){
            //MARK: Left handle
            if item.durationBased{
                RoundedRectangle(cornerRadius: wHandle/2)
                    .frame(width: wHandle)
                    .foregroundColor(Color(item.tags.colorName))
                    .padding(.horizontal, mHandle)
            } else {
                Circle()
                    .frame(width: wHandle + 4,height: wHandle + 4)
                    .foregroundColor(Color(item.tags.colorName))
                    .padding(.horizontal, mHandle - 2)
                
            }
            
            Button {
                changeViewPresented = true
            } label: {
                //MARK: Center tile
                ZStack(alignment:.top){
                    //MARK: Background tile
                    RoundedRectangle(cornerRadius: rTile).foregroundColor(Color(item.tags.colorName).opacity(opTile))
                    
                    //MARK: Title
                    VStack{
                        Text(item.titleIcon + " " + item.title)
                            .foregroundColor(Color("text_black"))
                            .font(.system(size: fsTitle))
                            .padding(.top,pTextVer)
                            .padding(.bottom,mTextVer)
                        HStack(spacing:mSmallTiles){
                            ZStack{
                                RoundedRectangle(cornerRadius: rSmallTile).foregroundColor(Color("background_white"))
                                Text(item.durationBased ? String(item.minutesTotal) : String(item.checkedTotal))
                                    .font(.system(size: fsSub))
                                    .fontWeight(.light)
                                    .foregroundColor(Color("text_black"))
                            }
                            .padding(.leading,mSmallTiles)
                            ZStack{
                                RoundedRectangle(cornerRadius: rSmallTile).foregroundColor(Color("background_white"))
                                Text("\(item.scoreTotal) pts")
                                    .font(.system(size: fsSub))
                                    .fontWeight(.light)
                                    .foregroundColor(Color("text_black"))
                            }
                            .padding(.trailing, mSmallTiles)
                        }
                        .padding(.bottom,mSmallTileVer)
                    }
                    
                } // End center tile ZStack
                
            }//end Button Label
            .sheet(isPresented: $changeViewPresented) {
                ChangeItemView(changeItemViewPresented: $changeViewPresented, item: item)
            }
        }
        
        
        //        // MARK: Design2
        //        ZStack{
        //            //MARK: Outline in the back
        //            RoundedRectangle(cornerRadius: 11)
        //                .stroke(Color(item.tags.colorName),style:StrokeStyle(lineWidth: 1))
        //                .padding(1)
        //            //MARK: Inside outline
        //            //MARK: Left
        //            HStack(spacing:5){
        //                if item.durationBased{
        //                    //MARK: Icon with Rectangular
        //                    ZStack{
        //                        RoundedRectangle(cornerRadius: 6)
        //                            .foregroundColor(Color(item.tags.colorName).opacity(0.2))
        //                        Text(item.titleIcon)
        //                            .font(.system(size: 15))
        //                    }.frame(width: 40, height: 58)
        //                    .padding(.leading, 7)
        //                } else {
        //                    //MARK: Icon with Circle
        //                    ZStack{
        //                        RoundedRectangle(cornerRadius: 20)
        //                            .foregroundColor(Color(item.tags.colorName).opacity(0.2))
        //                        Text(item.titleIcon)
        //                            .font(.system(size: 15))
        //                    }.frame(width: 40, height: 58)
        //                    .padding(.leading, 7)
        //                }
        //                //MARK: Right
        //                VStack(spacing:5){
        //                    //MARK: Title
        //                    ZStack{
        //                        RoundedRectangle(cornerRadius: 6)
        //                            .foregroundColor(Color(item.tags.colorName).opacity(0.2))
        //                        Text(item.title)
        //                            .font(.system(size: 15))
        //                            .fontWeight(.light)
        //                            .foregroundColor(Color("text_black"))
        //                    }.frame(height: 23)
        //                    //MARK: Statistics
        //                    HStack{
        //                        //MARK:Time/Hit
        //                        Spacer()
        //                        VStack{
        //                            Text(item.durationBased ? "Total Time" : "Total Hits")
        //                                .font(.system(size: 10))
        //                                .fontWeight(.light)
        //                                .foregroundColor(Color("text_black"))
        //                            Text(item.durationBased ? String(item.minutesTotal) : String(item.checkedTotal))
        //                                .font(.system(size: 15))
        //                                .fontWeight(.light)
        //                                .foregroundColor(Color("text_black"))
        //                        }
        //                        //MARK: Scores
        //                        Spacer()
        //                        VStack{
        //                            Text("Total Scores")
        //                                .font(.system(size: 10))
        //                                .fontWeight(.light)
        //                                .foregroundColor(Color("text_black"))
        //                            Text(String(item.scoreTotal))
        //                                .font(.system(size: 15))
        //                                .fontWeight(.light)
        //                                .foregroundColor(Color("text_black"))
        //
        //                        }
        //                        Spacer()
        //                    }
        //                }.frame(height:60).padding(.trailing, 7)
        //            }
        //        }.frame(height: 72)
        //        .onTapGesture {
        //            changeViewPresented = true
        //        }
        //                        .sheet(isPresented:$changeViewPresented, content: {
        //                            ChangeItemView(changeItemViewPresented: $changeViewPresented, item:item)
        //                        })
    }
}

//struct ItemTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemTileView()
//    }
//}
