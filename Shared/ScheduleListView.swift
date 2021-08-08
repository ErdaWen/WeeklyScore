//
//  ScheduleListView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/26/21.
//

import SwiftUI

struct ScheduleListView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var schedules: FetchedResults<Schedule>
    @State var addViewPresented = false
    @State var batchAddViewPresented = false
    //@State var zoomin = UserDefaults.standard.bool(forKey: "zoomedIn")
    @Binding var previewMode:Bool
    
    //Use factor for ordinary list view
    @State var factor = UserDefaults.standard.double(forKey: "listScaleFactor")
    //Use interCord for previewMode
    @State var interCord = 50.0
    
    let mButtonUp:CGFloat = 0
    let sButton:CGFloat = 22
    let mButtons:CGFloat = 10
    let mPicker:CGFloat = 40
    
    var body: some View {
        VStack{
            ZStack(alignment:.top){
                
                // MARK: Schedules list/preview main body
                if previewMode{
                    ScheduleListPreviewView(schedules: self.schedules,interCord:self.interCord)
                } else {
                    ScheduleListContentView(schedules: self.schedules,factor:self.factor)
                }
                
                //MARK: Top Buttons
                HStack(spacing:mButtons) {
                    Spacer()
                    FloatButton(systemName: "plus.square", sButton: sButton) {
                        addViewPresented = true
                    }
                    .sheet(isPresented: $addViewPresented, content: {
                        AddScheduleView(initDate: Date(),addScheduleViewPresented: $addViewPresented)
                    })
                    
                    
                    FloatButton(systemName: "plus.square.on.square", sButton: sButton) {
                        batchAddViewPresented = true
                    }
                    .sheet(isPresented: $batchAddViewPresented) {
                        AddBatchScheduleView(dayStart: propertiesModel.startDate, schedules: schedules, singleDay: false, addBatchScheduleViewPresented: $batchAddViewPresented)
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
                VStack{
                    Spacer()
                    if previewMode {
                        CustomSlider(interCord: $interCord, minValue: 35, maxValue: 90)
                            .frame(height:38)
                    } else {
                        
                        CustomSlider_list(factor: $factor, minValue: 0, maxValue: 30)
                            .frame(height:38)
                    }
                }
                .padding(.leading,80)
                .padding(.trailing,70)
                .padding(.bottom,18)
                
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
