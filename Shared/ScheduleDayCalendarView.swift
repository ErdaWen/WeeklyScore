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
    let topSpacing:CGFloat = 130
    let bottomSpacing:CGFloat = 50
    
    let updateTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollViewReader { scrollview in
            ScrollView{
                Spacer().frame(height:topSpacing)
                ZStack(alignment: .topLeading){
//                    GeometryReader {proxy in
//                        Color.clear.preference(key: ScrollPreferenceKey.self,
//                                               value: -proxy.frame(in: .named("scroll\(today)")).minY)
//                    }
//                    .onPreferenceChange(ScrollPreferenceKey.self) { value in
//                        propertiesModel.scrollPosition = value
//                    }
                    
                    scrollLocator
                    
                    timeLine
                    
                    ScheduleDayCalendarContentView(schedules: schedules, interCord: interCord,today:today)
                    
                    if propertiesModel.startDate == DateServer.startOfToday() {
                        NowLine(timeNow: timeNow, interCord: interCord)
                    }
                    
                } // end ZStack
                .padding(.trailing , 20)
                Spacer().frame(height:bottomSpacing)
            } // end scrollView
            .coordinateSpace(name: "scroll\(today)")
            .onAppear(){
                let scrollHour = propertiesModel.scrollPosition/interCord
                let scrollAnchor = 10000 + Int(scrollHour*4)
                scrollview.scrollTo(scrollAnchor,anchor: .top)
            }
//            .onChange(of: propertiesModel.dumScheculePageChange, perform: { _ in
//                let scrollHour = propertiesModel.scrollPosition/interCord
//                let scrollAnchor = 10000 + Int(scrollHour*4)
//                scrollview.scrollTo(scrollAnchor,anchor: .top)
//            })
            .onReceive(updateTimer) { _ in
                timeNow = Date()
            }
        }
    }
    
    var scrollLocator: some View{
        VStack{
            ForEach(10000..<10101,id:\.self){r in
                Spacer().id(r)
            }
        }
    }
    
    var timeLine:some View{
        ForEach (0...24, id:\.self){ r in
            HStack(alignment:.center, spacing:5){
                Text("\(r):00")
                    .foregroundColor(Color("text_black").opacity(0.5))
                    .font(.system(size: 12))
                    .padding(.leading, 20)
                VStack{
                    Divider()
                }
            }
            .frame(height:10)
            .padding(.top, CGFloat( Double(r) * interCord) )
        }
    }
}

//struct ScheduleDayCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDayCalendarView()
//    }
//}
