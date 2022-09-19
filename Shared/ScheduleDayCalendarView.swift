//
//  ScheduleDayCalendarView.swift
//  WeeklyScore (iOS)
//
//  Created by Erda Wen on 9/19/22.
//

import SwiftUI





struct ScheduleDayCalendarView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var schedules: FetchedResults<Schedule>
    var interCord: Double
    var today:Date

    @State var timeNow = Date()
    let topSpacing:CGFloat = 30
    let bottomSpacing:CGFloat = 50
    
    let updateTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollViewReader { scrollview in
            ZStack(alignment: .top){
                ScrollView{
                    Spacer()
                        .frame(height:topSpacing)
                    ZStack(alignment: .topLeading){
                        //MARK: Timeline background
                        ForEach (0...24, id:\.self){ r in
                            HStack(alignment:.center, spacing:5){
                                Text("\(r):00")
                                    .foregroundColor(Color("text_black").opacity(0.5))
                                    .font(.system(size: 12))
                                    .padding(.leading, 20)
                                VStack{
                                    Divider()
                                }
                                .id(r)
                            }
                            .frame(height:10)
                            .padding(.top, CGFloat( Double(r) * interCord) )
                        }
                        // end time line plot VStack
                        
                        //MARK: All schedules
                        ScheduleDayCalendarContentView(schedules: schedules, interCord: interCord,today:today)
                        
                        //MARK:Now line
                        if propertiesModel.startDate == DateServer.startOfToday() {
                            NowLine(timeNow: timeNow, interCord: interCord)
                        }
                        
                    } // end ZStack
                    .padding(.trailing , 20)
                    Spacer()
                        .frame(height:bottomSpacing)
                } // end scrollView
                .onAppear(){
                    scrollview.scrollTo(17)
                }
                
                
                
                //MARK: "No schedules" overlay
                if schedules.count == 0{
                    VStack(){
                        Spacer()
                        Text("No schedules for selected day")
                            .foregroundColor(Color("text_black"))
                            .font(.system(size: 18))
                            .fontWeight(.light)
                        Spacer()
                    }
                }
                
                
            }         // end button + scroll ZStack
            .onReceive(updateTimer) { _ in
                timeNow = Date()
            }
        }
    }
}

//struct ScheduleDayCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDayCalendarView()
//    }
//}
