//
//  ScheduleListPreviewView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/5/21.
//

import SwiftUI

struct ScheduleListPreviewView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var schedules: FetchedResults<Schedule>
    var interCord: Double
    @State var timeNow = Date()
    
    let updateTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    let mPicker:CGFloat = 40
    let topSpacing:CGFloat = 30
    
    var body: some View {
        
        ScrollViewReader { scrollview in
            ScrollView{
                // Whole Zstack
                ZStack{
                    //MARK: Vertical lines
                    ZStack{
                        GeometryReader { geo in
                            HStack(spacing:0){
                                ForEach(-1...6,id: \.self){ offDay in
                                    HStack{
                                        Spacer()
                                        Divider()
                                    }
                                    .padding(.vertical, -200)
                                    .frame(width: geo.frame(in: .global).width / 8)
                                }
                            }
                        }// end GeoReader
                    }.padding(.horizontal, mPicker) //end vertical lines
                    
                    // MARK:Everything except vertical line
                    VStack(alignment: .leading, spacing: 0){
                        // MARK: Spacing
                        Spacer()
                            .frame(height:topSpacing)
                        ZStack(alignment: .topLeading){
                            
                            //MARK: Horizental Timeline background
                            ForEach (0...24, id:\.self){ r in
                                HStack(alignment:.center, spacing:5){
                                    Text("\(r):00")
                                        .foregroundColor(Color("text_black").opacity(0.5))
                                        .font(.system(size: 12))
                                        .padding(.leading, 40)
                                    VStack{
                                        Divider().padding(.trailing, mPicker)
                                    }
                                    .id(r)
                                }
                                .frame(height:10)
                                .padding(.top, CGFloat( Double(r) * interCord) )
                            }// end timeline background
                            
                            
                            //MARK: Zstack within the picker frame
                            ZStack{
                                ScheduleListPreviewContentView(schedules: schedules, interCord: interCord, timeNow:timeNow)
                            }.padding(.horizontal, mPicker) // end ZStack with picker frame
                            
                            //MARK:Now line
                            if propertiesModel.startDate == DateServer.startOfThisWeek() {
                                NowLine(timeNow: timeNow, interCord: interCord)
                                    .padding(.leading, 17)
                                    .padding(.trailing, mPicker)
                            }//end now line if
                            
                        }// end everything except verticle line (and spacer) Zstack
                    }// end everything excepet vertical line Vstack
                }// end whole ZStack
            }//end scrollView
            .onAppear(){
                scrollview.scrollTo(17)
            }
            .onReceive(updateTimer) { _ in
                timeNow = Date()
            }
        }// end scrollReader
    }//end some view
}

//struct ScheduleListPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListPreviewView()
//    }
//}
