//
//  SelectWeekView.swift
//  WeeklyScore (iOS)
//
//  Created by Erda Wen on 9/24/22.
//

import SwiftUI

struct SelectWeekView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel

    @Binding var weekFromNow:Int
    @Binding var selectWeekViewPresented: Bool
    @State var selectedDay: Date = Date()
    
    let fsNavBar:CGFloat = 20
    let mNavBar:CGFloat = 25
    let fsForm:CGFloat = 16
    
    var body: some View {
        VStack(spacing: 20){
            navBar
            DatePicker("Go to Week of:", selection: $selectedDay,displayedComponents: .date)
                .foregroundColor(Color("text_black"))
                .font(.system(size: fsForm))
                .datePickerStyle(CompactDatePickerStyle())
                .onChange(of: selectedDay) { _ in
                    selectedDay = DateServer.startOfThisWeek(date: selectedDay)
                    let thisWeekStart = DateServer.startOfThisWeek()
                    let interval = selectedDay.timeIntervalSinceReferenceDate-thisWeekStart.timeIntervalSinceReferenceDate
                    weekFromNow = Int(interval/604800)
                }.padding(.horizontal,20)
            
            Button{
                selectWeekViewPresented = false
            } label: {
                Text("Done")
                    .foregroundColor(Color("text_blue"))
                    .font(.system(size: fsNavBar))
            }
            
            Spacer().frame(maxHeight: 5)
            Text("or")
                .foregroundColor(Color("text_black"))
            Spacer().frame(maxHeight: 5)
            
            Button {
                weekFromNow = 0
                selectWeekViewPresented = false
            } label: {
                Text("Back to this Week")
                    .foregroundColor(Color("text_blue"))
                    .font(.system(size: fsNavBar))
            }
            
            Spacer()
        }
        .onAppear{
            selectedDay = propertiesModel.startWeek
        }
    }
    
    var navBar:some View{
        HStack{
            Spacer()
            Text("Select a week")
                .font(.system(size: fsNavBar))
            Spacer()
        }.padding(mNavBar)
    }
}

//struct SelectWeekView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectWeekView()
//    }
//}
