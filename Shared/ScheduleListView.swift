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
    
    @State var schedules = [Schedule]()
    @State var zoomin = true
    
    func initiateView() {
        schedules = []
        print(schedules)
        let endDate = DateServer.addOneWeek(date: propertiesModel.startDate)
        let fetchRequest = Schedule.schedulefetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(beginTime >= %@) AND (beginTime < %@)", propertiesModel.startDate as NSDate, endDate as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "beginTime", ascending: true)]
        do {
            schedules = try viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        print("Fetched starts " + DateServer.printTime(inputTime: propertiesModel.startDate))
        print("Fetched ends " + DateServer.printTime(inputTime: endDate))
        print(schedules)
        
    }
    
    var body: some View {
        VStack{
            ZStack{
                
                ScrollView{
                    Spacer()
                        .frame(height:50)
                    if schedules.count != 0{
                        VStack{
                            // , id:\.self
                            ForEach(0..<schedules.count,id: \.self){ r in
                                
                                ScheduleTileView(schedule: schedules[r])
                                    .frame(height: zoomin ? 45 : 25)
                                
                            }
                        }
                        .padding(.horizontal,20)
                    }
                    
                    else {
                        Text("No entries for the selected week")
                            .foregroundColor(Color("text_black"))
                            .fontWeight(.light)
                            .font(.system(size: 12))
                    }
                    
                }
                // Buttons
                HStack{
                    Spacer()
                    
                    Spacer()
                }
                
            }
            
        }
        .onAppear(){
            print("\n")
            print("Start date initiated as " + DateServer.printTime(inputTime: propertiesModel.startDate))
            initiateView()
        }
        .onChange(of: propertiesModel.startDate) { _ in
            print("\n")
            print("Start date changes to " + DateServer.printTime(inputTime: propertiesModel.startDate))
            initiateView()
            
        }
    }
}

//struct ScheduleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleListView()
//    }
//}
