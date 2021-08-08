//
//  ScoreBar.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/6/21.
//

import SwiftUI

struct ScoreBar: View {
    @EnvironmentObject var propertiesModel:PropertiesModel

    let mScores:CGFloat = 10
    let mScoreTitle:CGFloat = 5
    let fsScore:CGFloat = 18.0

    var body: some View {
        HStack(spacing:mScores){
            if propertiesModel.deductScoreThisWeek != 0 {
                Text("-\(propertiesModel.deductScoreThisWeek)").font(.system(size: fsScore)).foregroundColor(Color("text_red"))
                Text(",").font(.system(size: fsScore)).foregroundColor(Color("text_black")).fontWeight(.light)
            }
            Text("\(propertiesModel.gainedScoreThisWeek)").font(.system(size: fsScore)).foregroundColor(Color("text_green"))
            Image(systemName: "line.diagonal").foregroundColor(Color("text_black"))
            Text("\(propertiesModel.totalScoreThisWeek)").font(.system(size: fsScore)).foregroundColor(Color("text_black"))
        }
        .padding(.bottom, mScoreTitle)
        .onAppear(){
            propertiesModel.updateScores()
        }
        .animation(.default)
        
        //            //MARK: Score bar
        //            GeometryReader{ geo in
        //                ZStack(alignment: .leading){
        //                    RoundedRectangle(cornerRadius: 5)
        //                        .stroke(Color("text_black"),style:StrokeStyle(lineWidth: 1))
        //                    if propertiesModel.totalScoreThisWeek != 0 {
        //                        RoundedRectangle(cornerRadius: 5)
        //                            .frame(width: geo.frame(in: .global)
        //                                    .width / CGFloat(propertiesModel.totalScoreThisWeek) * CGFloat(propertiesModel.gainedScoreThisWeek + propertiesModel.deductScoreThisWeek)
        //                            )
        //                            .foregroundColor(Color("text_green").opacity(0.6))
        //                        RoundedRectangle(cornerRadius: 5)
        //                            .frame(width: geo.frame(in: .global)
        //                                    .width / CGFloat(propertiesModel.totalScoreThisWeek) * CGFloat(propertiesModel.deductScoreThisWeek)
        //                            )
        //                            .foregroundColor(Color("text_red"))
        //                    }
        //                }
        //            }
    }
}

struct ScoreBarView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBar()
    }
}
