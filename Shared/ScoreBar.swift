//
//  ScoreBar.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/6/21.
//

import SwiftUI

struct ScoreBar: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @State var showDetial = false
    
    let mode = UserDefaults.standard.integer(forKey: "autoCompleteMode")
    let mScores:CGFloat = 10
    let mScoreTitle:CGFloat = 0
    let fsScore:CGFloat = 18.0
    let fsSub:CGFloat = 16

    var body: some View {
        
        ZStack{
            if showDetial{
                detailedBar
            } else {
                previewBar
            }
        }
        .frame(height: 20)
        .padding(.bottom, mScoreTitle)
        .onAppear(){
            propertiesModel.updateScores()
        }
        .onTapGesture {
            if showDetial{
                withAnimation(.easeInOut){
                    showDetial = false
                }
            } else{
                withAnimation(.easeInOut){
                    showDetial = true
                }
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { timer in
                    withAnimation(.easeInOut){
                        showDetial = false
                    }
                }
            }
        }
        .animation(.default)
    }
    var detailedBar: some View {
        HStack(spacing: mScores) {
            Text("Complete: \(propertiesModel.gainedScoreThisWeek)")
                .font(.system(size: fsSub))
                .foregroundColor(Color("text_green"))
                .fontWeight(.semibold)

            Text("Fail: \(propertiesModel.deductScoreThisWeek)")
                .font(.system(size: fsSub))
                .foregroundColor(Color("text_red"))
                .fontWeight(.semibold)

            if mode == 3{
                Text("Unrecorded: \(propertiesModel.totalScoreThisWeek - propertiesModel.deductScoreThisWeek - propertiesModel.gainedScoreThisWeek)")
                    .font(.system(size: fsSub))
                    .foregroundColor(Color("text_black"))
                    .fontWeight(.semibold)

            } else {
                Text("Upcoming: \(propertiesModel.totalScoreThisWeek - propertiesModel.deductScoreThisWeek - propertiesModel.gainedScoreThisWeek)")
                    .font(.system(size: fsSub))
                    .foregroundColor(Color("text_black"))
                    .fontWeight(.semibold)

  
            }
        }
    }
    
    var previewBar: some View {
        HStack(spacing: mScores) {
            if propertiesModel.deductScoreThisWeek != 0 {
                Text("-\(propertiesModel.deductScoreThisWeek)")
                    .font(.system(size: fsScore))
                    .foregroundColor(Color("text_red"))
                    .fontWeight(.bold)
                Text(",")
                    .font(.system(size: fsScore))
                    .foregroundColor(Color("text_black"))
                    .fontWeight(.bold)
            }
            Text("\(propertiesModel.gainedScoreThisWeek)")
                .font(.system(size: fsScore))
                .foregroundColor(Color("text_green"))
                .fontWeight(.bold)
            Image(systemName: "line.diagonal")
                .foregroundColor(Color("text_black"))
            Text("\(propertiesModel.totalScoreThisWeek)")
                .font(.system(size: fsScore))
                .foregroundColor(Color("text_black"))
                .fontWeight(.bold)
        }
    }
    
    var lineBar: some View {
        GeometryReader{ geo in
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("text_black"),style:StrokeStyle(lineWidth: 1))
                if propertiesModel.totalScoreThisWeek != 0 {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: geo.frame(in: .global)
                                .width / CGFloat(propertiesModel.totalScoreThisWeek) * CGFloat(propertiesModel.gainedScoreThisWeek + propertiesModel.deductScoreThisWeek)
                        )
                        .foregroundColor(Color("text_green").opacity(0.6))
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: geo.frame(in: .global)
                                .width / CGFloat(propertiesModel.totalScoreThisWeek) * CGFloat(propertiesModel.deductScoreThisWeek)
                        )
                        .foregroundColor(Color("text_red"))
                }
            }
        }
    }
}

struct ScoreBarView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBar()
    }
}
