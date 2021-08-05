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
    let updateTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    func autoRecord() {
        if mode != 3 {
            changedSchedules = AutoRecordServer.autoRecord(mode: mode, weekStart: DateServer.startOfThisWeek())
            print("\(changedSchedules.count) schedule completion auto changed.")
            
            if changedSchedules.count > 0 {
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                    withAnimation(.easeInOut){
                        propertiesModel.updateScores()
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
            
            if autoRecordNotification{
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color( mode == 0 ? "text_green" : "text_red"))
                        Text("\(changedSchedules.count) " + (changedSchedules.count == 1 ? "schedule " : "schedules ") + "marked as " + (mode == 0 ? "complete automatically..." : "incomplete automatically..."))
                            .font(.system(size: 12))
                            .foregroundColor(Color("text_black"))
                    }
                    .frame(height:20)
                    .padding(.horizontal,20)
                    .transition(.opacity)
                    Spacer()
                }
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
