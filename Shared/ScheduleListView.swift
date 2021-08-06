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
    //@State var zoomin = UserDefaults.standard.bool(forKey: "zoomedIn")
    @Binding var previewMode:Bool
    
    //Use factor for ordinary list view
    @State var factor = UserDefaults.standard.double(forKey: "listScaleFactor")
    //Use interCord for previewMode
    @State var interCord = 50.0
    
    let mHorizon:CGFloat = 20
    let mButtonUp:CGFloat = 10
    let sButton:CGFloat = 22
    let mButtons:CGFloat = 16
    let mTitleButton:CGFloat = 3
    let topSpacing:CGFloat = 40
    let mPicker:CGFloat = 40



    
    var body: some View {
        VStack{
            ZStack(alignment:.top){
                
                if previewMode{
                    ScheduleListPreviewView(schedules: self.schedules,interCord:self.interCord)
                } else {
                    ScheduleListContentView(schedules: self.schedules,factor:self.factor)
                }
                
                //MARK: Top Buttons
                
                HStack{
                    Spacer()
                    Button {
                        addViewPresented = true
                    } label: {
                        Image(systemName: "plus.square")
                            .resizable().scaledToFit()
                            .padding(.horizontal, mButtons).frame(height:sButton)
                            .padding(.vertical, mTitleButton)
                            .foregroundColor(Color("text_black"))
                            .background(
                                RadialGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                            )
                    }
                    .sheet(isPresented: $addViewPresented, content: {
                        AddScheduleView(initDate: Date(),addScheduleViewPresented: $addViewPresented)
                    })
                    
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "plus.square.on.square")
                            .resizable().scaledToFit()
                            .padding(.horizontal, mButtons).frame(height:sButton)
                            .padding(.vertical, mTitleButton)
                            .foregroundColor(Color("text_black"))
                            .background(
                                RadialGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0)]), center: .center, startRadius: 5, endRadius: 20)
                            )
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
                                Rectangle()
                                    .foregroundColor(Color("background_white").opacity(0.7))
                                Rectangle()
                                    .stroke(Color("background_grey"),lineWidth: 2)
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
                    HStack(spacing: mButtons){
                        if previewMode {
                            
                            CustomSlider(interCord: $interCord, minValue: 35, maxValue: 90)
                                .padding(.leading,80)
                                .padding(.trailing,70)
                                .padding(.bottom,18)
                                .frame(height:55)
                        } else {

                            CustomSlider_list(factor: $factor, minValue: 0, maxValue: 30)
                                .padding(.leading,80)
                                .padding(.trailing,70)
                                .padding(.bottom,18)
                                .frame(height:55)
                        }
                    }
                }

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
