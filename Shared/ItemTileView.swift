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
    let wSmallTile:CGFloat = 120
    let opTile:Double = 0.15
    let pText:CGFloat = 8
    let mTextVer:CGFloat = 0
    let pTextHorTight:CGFloat = 5
    let hTiles:CGFloat = 45

    
    var body: some View {
        
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
                    RoundedRectangle(cornerRadius: rTile).stroke(Color(item.tags.colorName), lineWidth: 0.5)
                    RoundedRectangle(cornerRadius: rTile).foregroundColor(Color(item.tags.colorName).opacity(opTile))
                    
                    //MARK: Title
                    HStack{
                        Text(item.titleIcon + " " + item.title)
                            .foregroundColor(Color("text_black"))
                            .font(.system(size: fsTitle))
                            .padding(.leading,pText)
                            .padding(.bottom,mTextVer)
                        Spacer()
                        ZStack(){
                            
                                RoundedRectangle(cornerRadius: rSmallTile).foregroundColor(Color("background_white"))
                            Text(item.durationBased ? DateServer.describeMin(min: Int(item.minutesTotal))  : "\(item.checkedTotal) times")
                                    .font(.system(size: fsSub))
                                    .fontWeight(.light)
                                    .foregroundColor(Color("text_black"))
                            }
                        .frame(width:wSmallTile)
                        .padding(.trailing,mSmallTiles)
                        .padding(.vertical,mSmallTileVer)
                    }
                    
                } // End center tile ZStack
                
            }//end Button Label
            .sheet(isPresented: $changeViewPresented) {
                ChangeItemView(changeItemViewPresented: $changeViewPresented, item: item)
            }
        }//end everything Hstack
        .frame(height:hTiles)
    }
}

//struct ItemTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemTileView()
//    }
//}
