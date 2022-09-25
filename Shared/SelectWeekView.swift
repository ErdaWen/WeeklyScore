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
    @State var selectedDayReal: Date = Date()
    
    let fsNavBar:CGFloat = 20
    let mNavBar:CGFloat = 25
    let fsForm:CGFloat = 16
    
    var body: some View {
        VStack(spacing: 10){
 //           navBar
            Spacer().frame(maxHeight: 20)
            DatePicker("Go to Week of:", selection: $selectedDay,displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .foregroundColor(Color("text_black"))
                .font(.system(size: fsForm))
                .datePickerStyle(CompactDatePickerStyle())
                .onChange(of: selectedDay) { _ in
                    selectedDayReal = DateServer.startOfThisWeek(date: selectedDay)
                    let thisWeekStart = DateServer.startOfThisWeek()
                    let interval = selectedDayReal.timeIntervalSinceReferenceDate-thisWeekStart.timeIntervalSinceReferenceDate
                    weekFromNow = Int(interval/604800)
                }.padding(.horizontal,20)
            
//            Button{
//                selectWeekViewPresented = false
//            } label: {
//                Text("Go")
//                    .foregroundColor(Color("text_blue"))
//                    .font(.system(size: fsNavBar))
//            }.padding(.bottom,10)
            Button {
                weekFromNow = 0
            } label: {
                Text("Back to this Week")
                    .foregroundColor(Color("text_blue"))
                    .font(.system(size: fsNavBar))
            }
            
            Spacer()
        }
        .onAppear{
            selectedDay = propertiesModel.startWeek
            selectedDayReal = selectedDay
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
