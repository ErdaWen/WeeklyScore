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
    @State var showDetail = false
    @State var minTot:Int64 = 0
    @State var checkTot:Int64 = 0
    @State var ptsTot:Int64 = 0
    @State var rate:Double? = nil
    @State var dates:[Date] = []
    @State var value:[Int] = []
    
    let fsTitle:CGFloat = 16
    let fsSub:CGFloat = 16
    let wHandle:CGFloat = 10
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
    let hTilesDetail:CGFloat = 250
    let sButton:CGFloat = 17
    
    
    func updateItem() {
        item.scoreTotal = ptsTot
        item.checkedTotal = checkTot
        item.minutesTotal = minTot
        do {
            try viewContext.save()
            print("Item statisics saved")
        } catch {
            print(error)
        }
    }
    
    
    var body: some View {
        HStack(spacing:0){
            if item.durationBased{
                handleDur
            } else {
                handlePnt
            }

            //MARK: Center tile
            ZStack(alignment:.top){
                RoundedRectangle(cornerRadius: rTile).stroke(Color(item.tags.colorName), lineWidth: 1)
                RoundedRectangle(cornerRadius: rTile).foregroundColor(Color(item.tags.colorName).opacity(opTile))
                VStack(alignment: .center, spacing: 0){
                    titleLine
                        .frame(height:45)
                    if showDetail{
                        ItemStatisticBars(dates: dates, values: value, durationBased: item.durationBased,color: Color(item.tags.colorName))
                            .padding(.horizontal, 10)
                            .animation(.default)
                        statisticSummary
                            .frame(height: 20)
                            .padding(.horizontal,10)
                            .padding(.vertical, 10)
                    }
                }// end VStack
            } // End center tile ZStack
            .onTapGesture {
                withAnimation(.default) {
                    showDetail.toggle()
                }
            }
            .onChange(of: showDetail) { _ in
                (minTot, checkTot, ptsTot, rate, dates, value) = StatisticServer.goThroughItem(item: item)
                updateItem()
            }
            .sheet(isPresented: $changeViewPresented) {
                ChangeItemView(changeItemViewPresented: $changeViewPresented, item: item)
                    .environment(\.managedObjectContext,self.viewContext)
            }
        }//end everything Hstack
        .frame(height: showDetail ? hTilesDetail : hTiles)
    }
    var handleDur:some View{
        RoundedRectangle(cornerRadius: wHandle/2)
            .frame(width: wHandle)
            .foregroundColor(Color(item.tags.colorName))
            .padding(.horizontal, mHandle)
    }
    var handlePnt:some View{
        Circle()
            .frame(width: wHandle + 4,height: wHandle + 4)
            .foregroundColor(Color(item.tags.colorName))
            .padding(.horizontal, mHandle - 2)
    }
    
    var titleLine:some View{
        HStack(alignment:.center){
            //MARK: Title
            Text(item.titleIcon + " " + item.title)
                .strikethrough(item.hidden)
                .foregroundColor(Color(item.tags.colorName+"_text"))
                .font(.system(size: fsTitle))
                .fontWeight(.regular)
                .padding(.leading,pText)
                .padding(.bottom,mTextVer)
            
            //MARK: Edit button
            if showDetail{
                Button {
                    changeViewPresented = true
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable().scaledToFit()
                        .foregroundColor(Color("text_black"))
                        .frame(height:sButton).padding(.leading,3)
                }
            }
            Spacer()
            //MARK: Show detail/rough statisitc
            if showDetail{
                Button {
                    withAnimation(.default){
                    showDetail = false
                    }
                } label: {
                    Image(systemName: "chevron.up")
                        .resizable().scaledToFit()
                        .foregroundColor(Color("text_black"))
                        .frame(width:sButton,height:sButton).padding(.leading,3)
                        .padding(.trailing,mSmallTiles)
                        .padding(.vertical,mSmallTileVer)
                }
                
            } else {
                ZStack(){
                    RoundedRectangle(cornerRadius: rSmallTile).foregroundColor(Color("background_white"))
                    Text(item.durationBased ? DateServer.describeMin(min: Int(item.minutesTotal))  : "\(item.checkedTotal) times")
                        .font(.system(size: fsSub))
                        .fontWeight(.regular)
                        .foregroundColor(Color("text_black"))
                }
                .frame(width:wSmallTile)
                .padding(.trailing,mSmallTiles)
                .padding(.vertical,mSmallTileVer)
            }//end if else
            
        }
    }
    
    var statisticSummary:some View{
        HStack{
            ZStack(){
                RoundedRectangle(cornerRadius: rSmallTile).foregroundColor(Color("background_white"))
                Text(item.durationBased ? DateServer.describeMin(min: Int(item.minutesTotal))  : "\(item.checkedTotal) times")
                    .font(.system(size: fsSub))
                    .fontWeight(.regular)
                    .foregroundColor(Color("text_black"))
            }
            
            ZStack(){
                RoundedRectangle(cornerRadius: rSmallTile).foregroundColor(Color("background_white"))
                Text("\(item.scoreTotal) pts")
                    .font(.system(size: fsSub))
                    .fontWeight(.regular)
                    .foregroundColor(Color("text_black"))
            }
            .frame(height:20)
            
            ZStack(){
                RoundedRectangle(cornerRadius: rSmallTile).foregroundColor(Color("background_white"))
                if let r = rate {
                    Text("\(Int(r*100)) % ")
                        .font(.system(size: fsSub))
                        .fontWeight(.regular)
                        .foregroundColor(Color("text_black"))
                } else {
                    Text(" - % ")
                        .font(.system(size: fsSub))
                        .fontWeight(.regular)
                        .foregroundColor(Color("text_black"))
                }
                
            }
            .frame(height:20)
        }
    }
    
}

//struct ItemTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemTileView()
//    }
//}
