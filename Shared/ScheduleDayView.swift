//
//  ScheduleDayView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/31/21.
//

import SwiftUI

struct ScheduleDayView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var schedules: FetchedResults<Schedule>
    var today:Date
    @State var addViewPresented = false
    @State var batchAddViewPresented = false

    //Use factor for list style view
    var factor:CGFloat
    //Use interCord for calender style view
    var interCord:CGFloat
    var previewMode:Bool
    
    @GestureState var pinchStarted = false
    //@State var pinchValue: CGFloat = 0
    //@State var lastInterCord = 50.0
    
    let mButtonUp:CGFloat = 0
    let sButton:CGFloat = 22
    let mButtons:CGFloat = 10
    
    // Commit push test
    var body: some View {
        ZStack(alignment:.top){
            if previewMode{
                ScheduleDayCalendarView(schedules: self.schedules,interCord:self.interCord, today: self.today)
            } else {
                ScheduleDayListView(schedules: self.schedules,factor:self.factor)
            }
            
            //MARK: Buttons
            HStack (spacing:mButtons) {
                Spacer()
                
                FloatButton(systemName: "plus.square", sButton: sButton) {
                    addViewPresented = true
                }
                .sheet(isPresented: $addViewPresented, content: {
                    AddScheduleView(initDate: propertiesModel.startDate, addScheduleViewPresented: $addViewPresented)
                        .environment(\.managedObjectContext,self.viewContext)
                })
                
                
                FloatButton(systemName: "plus.square.on.square", sButton: sButton) {
                    batchAddViewPresented = true
                }
                .sheet(isPresented: $batchAddViewPresented) {
                    DayBatchOperationView(dayStart: propertiesModel.startDate, schedules: schedules, singleDay: true, addBatchScheduleViewPresented: $batchAddViewPresented)
                        .environment(\.managedObjectContext,self.viewContext)
                }
                Spacer()
            } // end button HStack
            .padding(.top,mButtonUp)
            
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
            
        }//end Zstack

        //end ScrollViewReader
        //        .gesture(
        //            MagnificationGesture()
        //                //                    .updating($pinchStarted, body: { value, out, _ in
        //                //                        out = true
        //                //                    })
        //                .onChanged({ value in
        //
        //                    print("value: \(value)")
        //                    interCord = min(max(lastInterCord + Double(value-1)*30,35),90)
        //
        //
        //                })
        //                .onEnded({ value in
        //                    lastInterCord = interCord
        //
        //
        //                })
        //        )
        
        
    }// end view
}// end struct

//struct ScheduleDayView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDayView()
//    }
//}
