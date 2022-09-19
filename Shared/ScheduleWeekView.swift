//
//  ScheduleListView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/26/21.
//

import SwiftUI

struct ScheduleWeekView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var schedules: FetchedResults<Schedule>
    @State var addViewPresented = false
    @State var batchAddViewPresented = false
    //@State var zoomin = UserDefaults.standard.bool(forKey: "zoomedIn")
    @Binding var previewMode:Bool
    
    //Use factor for ordinary list view
    var factor:CGFloat
    //Use interCord for previewMode
    var interCord:CGFloat
    
    let mButtonUp:CGFloat = 0
    let sButton:CGFloat = 22
    let mButtons:CGFloat = 10
    let mPicker:CGFloat = 40
    
    var body: some View {
        VStack{
            ZStack(alignment:.top){
                
                // MARK: Schedules list/preview main body
                if previewMode{
                    ScheduleWeekCalendarView(schedules: self.schedules,interCord:self.interCord)
                } else {
                    ScheduleWeekListView(schedules: self.schedules,factor:self.factor)
                }
                
                //MARK: Top Buttons
                HStack(spacing:mButtons) {
                    Spacer()
                    FloatButton(systemName: "plus.square", sButton: sButton) {
                        addViewPresented = true
                    }
                    .sheet(isPresented: $addViewPresented, content: {
                        AddScheduleView(initDate: Date(), addScheduleViewPresented: $addViewPresented)
                            .environment(\.managedObjectContext,self.viewContext)
                    })
                    
                    
                    FloatButton(systemName: "plus.square.on.square", sButton: sButton) {
                        batchAddViewPresented = true
                    }
                    .sheet(isPresented: $batchAddViewPresented) {
                        WeekBatchOpearationView(dayStart: propertiesModel.startDate, schedules: schedules, singleDay: false, addBatchScheduleViewPresented: $batchAddViewPresented)
                            .environment(\.managedObjectContext,self.viewContext)
                    }
                    
                    Spacer()
                } //end top Buttons HStack
                .padding(.top,mButtonUp)
                // end top buttons
                
                //MARK: "No schedules" overlay
                if schedules.count == 0 {
                    VStack(){
                        Spacer()
                        Text("No schedules for selected week")
                            .foregroundColor(Color("text_black"))
                            .font(.system(size: 18))
                            .fontWeight(.light)
                        Spacer()
                    }
                    
                }// end display No schedule
            }
        }
    }
}

//struct ScheduleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListView()
//    }
//}
