//
//  WeekPicker.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/7/21.
//

import SwiftUI

struct WeekPicker: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    @Binding var weekFromNow:Int
    @Binding var dayFromDay1:Int
    @State var selectWeekViewPresented = false
    
    let rTile:CGFloat = 12
    let sButton:CGFloat = 22
    let mButton:CGFloat = 10
    let fsTitle:CGFloat = 18.0

    var body: some View {
        ZStack{
            // Background tile
            RoundedRectangle(cornerRadius: rTile)
                .foregroundColor(Color("background_grey"))
            
            HStack{
                //MARK: Week minus
                Button {
                    weekFromNow -= 1
                    dayFromDay1 = -1
                } label: {
                    //Image(systemName: "arrowtriangle.backward.square")
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height:16)
                        .foregroundColor(Color("text_black"))
                }
                .frame(width: sButton,
                       height: sButton)
                .padding(.leading,mButton)
                
                Spacer()
                
                //MARK: Week Selection
                Button {
                    selectWeekViewPresented = true
                    dayFromDay1 = -1
                } label: {
                    Text(weekFromNow == 0 ? "This week" : "Week of " + DateServer.generateStartDay(offset:weekFromNow) )
                        .foregroundColor(Color("text_black"))
                        .font(.system(size: fsTitle))
                        .fontWeight(.light)
                }
                .sheet(isPresented: $selectWeekViewPresented) {
                    if #available(iOS 16.0, *) {
                        SelectWeekView(weekFromNow:$weekFromNow,
                                       selectWeekViewPresented:$selectWeekViewPresented)
                        .environment(\.managedObjectContext,self.viewContext)
                        .presentationDetents([.medium,.large])
                    } else {
                        SelectWeekView(weekFromNow:$weekFromNow,
                                       selectWeekViewPresented:$selectWeekViewPresented)
                        .environment(\.managedObjectContext,self.viewContext)
                    }
                }
                
                Spacer()
                
                //MARK: Week plus
                Button {
                    weekFromNow += 1
                    dayFromDay1 = -1
                } label: {
                    //Image(systemName: "arrowtriangle.right.square")
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(height:16)
                        .foregroundColor(Color("text_black"))
                }
                .frame(width: sButton, height: sButton)
                .padding(.trailing,mButton)
            }
        } // end ZStack
        
    }
}

//struct WeekPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekPicker()
//    }
//}
