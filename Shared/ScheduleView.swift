//
//  ScheduleView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI
import UIKit

struct ScheduleView: View {
    
    @State var addViewPresented = false
    @State var showDeduct = false
    
    @Environment(\.managedObjectContext) private var viewContext    
    @EnvironmentObject var propertiesModel:PropertiesModel

    
    var body: some View {
        VStack{
            HStack(spacing:10){
                if showDeduct {
                    Text("-\(propertiesModel.deductScoreThisWeek)")
                        .font(.system(size: 25))
                        .foregroundColor(Color("text_red"))
                        .fontWeight(.light)
                } else{
                    Text("-\(propertiesModel.gainedScoreThisWeek)")
                        .font(.system(size: 25))
                        .foregroundColor(Color("text_green"))
                        .fontWeight(.light)
                }
                Image(systemName: "line.diagonal")
                    .foregroundColor(Color("text_black"))
                Text("\(propertiesModel.totalScoreThisWeek)")
                    .font(.system(size: 25))
                    .foregroundColor(Color("text_black"))
                    .fontWeight(.light)
            }
            .onAppear(){
                propertiesModel.updateScores()
            }
            .onTapGesture {
                showDeduct.toggle()
            }
            .animation(.default)
            
            ScheduleListView()

            Button("Add Schedule") {addViewPresented.toggle()}.sheet(isPresented: $addViewPresented, content: {
                AddScheduleView(addScheduleViewPresented: $addViewPresented)
            })
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
