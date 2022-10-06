//
//  ContentView.swift
//  Shared
//
//  Created by Erda Wen on 7/3/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    @State var tabIndex = 1
    @State var autoRecordNotification = false
    let mode = UserDefaults.standard.integer(forKey: "autoCompleteMode")
    @State var changedSchedules:[Schedule] = []
    @State var changedSchedulesNumber:Int = 0
    let updateTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    func autoRecord() {
        if mode != 3 {
            changedSchedules = AutoRecordServer.autoRecord(mode: mode, weekStart: DateServer.startOfThisWeek())
            print("\(changedSchedules.count) schedule completion auto changed.")
            if changedSchedules.count > 0 {
                
                changedSchedulesNumber = changedSchedules.count
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                    withAnimation(.easeInOut){
                        propertiesModel.updateScores()
                        propertiesModel.dumUpdate.toggle()
                        autoRecordNotification = true
                    }
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                }
                Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { timer in
                    withAnimation(.easeInOut){
                        autoRecordNotification = false
                    }
                }
            }
        }// end if mode!=3
    }

    var body: some View {
        ZStack(alignment:.top){
            ZStack{
                switch tabIndex{
                case 2:
                    ItemView()
                case 3:
                    SettingView()
                default:
                    ScheduleView()
                }
                VStack{
                    Spacer()
                    threeButtons
                        .frame(height: 45)
                }
            }
            
            //MARK: autorecord noification bar
            if autoRecordNotification{
                AutoRecordNotificationBar (count: changedSchedulesNumber, mode:mode)
            }
            
        }
        .onAppear(){
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                autoRecord()
            }
            print("excecuted auto record")

        }
        .onReceive(updateTimer) { _ in
            autoRecord()
            print("excecuted auto record")
        }
    }
    
    var threeButtons: some View{
        HStack{
            Spacer()
            tabButton(imageName: "calendar.badge.clock",
                      titleText: "Schedule",
                      selected: (tabIndex == 1))
            .onTapGesture {
                tabIndex = 1
            }

            Spacer()
            
            tabButton(imageName: "flag.filled.and.flag.crossed",
                      titleText: "Habits",
                      selected: (tabIndex == 2))
            .onTapGesture {
                tabIndex = 2
            }

            Spacer()
            tabButton(imageName: "gear",
                      titleText: "Settings",
                      selected: (tabIndex == 3))
            .onTapGesture {
                tabIndex = 3
            }

            Spacer()
        }// end Hstack
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
