//
//  InputField.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/7/21.
//

import SwiftUI

struct InputField <Content:View>: View {
    
    let content:Content
    var title: String?
    var alignment: HorizontalAlignment
    var color:Color
    var fieldHeight:CGFloat?
    
    
    let rBoarder:CGFloat = 8
    let wBoarder:CGFloat = 1.5
    let mTitleField:CGFloat = 7
    let fsTitle:CGFloat = 15


    init( title:String?,  alignment: HorizontalAlignment,  color:Color,  fieldHeight:CGFloat?, @ViewBuilder content:() -> Content) {
        self.title = title
        self.alignment = alignment
        self.color = color
        self.fieldHeight = fieldHeight
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: self.alignment, spacing: mTitleField){
            if let t = title {
                Text(t)
                    .font(.system(size: fsTitle))
                    .foregroundColor(Color("text_black"))
                    .fontWeight(.light)
            }
            
            ZStack(alignment: .center){
                RoundedRectangle(cornerRadius: rBoarder)
                    .stroke(self.color,style:StrokeStyle(lineWidth: wBoarder))
                    .animation(.default)                
                self.content
            }
            .frame(height: fieldHeight)
        }
    }
}

//struct InputField_Previews: PreviewProvider {
//    static var previews: some View {
//        InputField()
//    }
//}