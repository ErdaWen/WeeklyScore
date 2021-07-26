//
//  HabitView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI

struct ItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var addViewPresented = false
    @State var changeViewPresented = false
    
    var body: some View {
        VStack{
            Button {
                addViewPresented.toggle()
            } label: {
                Image(systemName: "plus.square")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 30)
                    .foregroundColor(Color("text_black"))
                    .frame(width: 60, height: 60)

            }
            .sheet(isPresented: $addViewPresented, content: {
                AddItemView(addItemViewPresented: $addViewPresented)
            })

            if items.count > 0{
                TabView{
                    ForEach(0..<items.count, id: \.self) { r in
                        //if habitModel.habits[r].hidden == false {
                            HStack{
                                Rectangle().frame(width: 40, height: 40).foregroundColor(Color(items[r].tags.colorName)).cornerRadius(8.0)
                                Button(items[r].titleIcon + items[r].title) {
                                    changeViewPresented = true
                                }.sheet(isPresented: $changeViewPresented, content: {
                                    ChangeItemView(changeItemViewPresented: $changeViewPresented, item:items[r])
                                })
                                if items[r].durationBased {
                                    Text("Total \(items[r].minutesTotal) minutes")
                                } else {
                                    Text("\(items[r].checkedTotal) times hited")
                                }
                                Text(String(items[r].scoreTotal))
                            }
                        //}
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
        }
        .padding()
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
