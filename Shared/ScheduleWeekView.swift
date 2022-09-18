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
                
                //MARK: Preview Button
                //Zstack with picker frame
                ZStack{
                    GeometryReader{ geo in
                        HStack{
                            ZStack{
                                // Stroke
                                Rectangle()
                                    .foregroundColor(Color("background_white").opacity(0.7))
                                // Transparent white background
                                Rectangle()
                                    .stroke(Color("background_grey"),lineWidth: 2)
                                // button
                                Button {
                                    previewMode.toggle()
                                    UserDefaults.standard.set(previewMode,forKey: "previewMode")
                                } label: {
                                    
                                    Image(systemName: previewMode ? "list.dash" : "calendar")
                                        .resizable().scaledToFit()
                                        .frame(height: previewMode ? 11: 14)
                                        .padding(.top,0)
                                        .foregroundColor(Color("text_black"))
                                }
                            }.frame(width: geo.frame(in: .global).width / 8 )//end button Zstack
                            Spacer()
                        }.frame(height:40)
                    }// end georeader
                }.padding(.horizontal,mPicker) // end zstack with picker frame
                
                // MARK: Sliders
//                VStack{
//                    Spacer()
//                    ZStack{
//                        Rectangle()
//                            .fill(LinearGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0.6),Color("background_white").opacity(0)]), startPoint: .bottom, endPoint: .top))
//                        if previewMode {
//                            CustomSlider(interCord: $interCord, minValue: 35, maxValue: 90)
//                                .frame(height:38)
//                                .padding(.leading,80)
//                                .padding(.trailing,70)
//                        } else {
//                            CustomSlider_list(factor: $factor, minValue: 0, maxValue: 30)
//                                .frame(height:38)
//                                .padding(.leading,80)
//                                .padding(.trailing,70)
//                        }
//                    }.frame(height:75)
//                }
                

                
                // "No schedules" overlay
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