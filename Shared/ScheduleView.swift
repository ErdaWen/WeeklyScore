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
    @State var weekFromNow = 0
    @State var dayFromDay1 = 0
    
    @Environment(\.managedObjectContext) private var viewContext    
    @EnvironmentObject var propertiesModel:PropertiesModel

    
    var body: some View {
        VStack(spacing:0){
            //MARK: Score
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
            .padding(.bottom,2)
            //MARK: Bar
            GeometryReader{ geo in
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color("text_black"),style:StrokeStyle(lineWidth: 1))
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: geo.frame(in: .global)
                                .width / CGFloat(propertiesModel.totalScoreThisWeek) * CGFloat(propertiesModel.gainedScoreThisWeek + propertiesModel.deductScoreThisWeek)
                        )
                        .foregroundColor(Color("text_green").opacity(0.6))
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: geo.frame(in: .global)
                                .width / CGFloat(propertiesModel.totalScoreThisWeek) * CGFloat(propertiesModel.gainedScoreThisWeek)
                        )
                        .foregroundColor(Color("text_red"))
                }
            }
            .frame(height:8)
            .padding(.leading,110)
            .padding(.trailing,110)
            .padding(.bottom,1)
            ScheduleListView()
            
            Spacer()

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
