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
    let updateTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    func autoRecord() {
        if mode != 3 {
            changedSchedules = AutoRecordServer.autoRecord(mode: mode, weekStart: DateServer.startOfThisWeek())
            print("\(changedSchedules.count) schedule completion auto changed.")
            if changedSchedules.count > 0 {
                
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
                
            TabView(selection: $tabIndex){
                // MARK: Schedule View
                ScheduleView()
                    .tabItem {
                        VStack{
                            Image (systemName: "calendar.badge.clock")
                            Text ("Schedule").fontWeight(.light)
                        }
                    }.tag(1)
                // MARK: Habit View
                ItemView()
                    .tabItem {
                        VStack{
                            Image (systemName: "flag")
                            Text ("Habits").fontWeight(.light)
                        }
                        
                    }.tag(2)
                SettingView()
                    .tabItem{
                        VStack{
                            Image (systemName:"gear")
                            Text("Settings").fontWeight(.light)
                        }
                    }.tag(3)
            }
            
            //MARK: autorecord noification bar
            if autoRecordNotification{
                AutoRecordNotificationBar (count: changedSchedules.count, mode:mode)
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
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
