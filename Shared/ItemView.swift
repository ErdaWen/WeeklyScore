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
    @State var changeId = 0
    
    var body: some View {
        VStack(spacing:30){
            Button {
                addViewPresented.toggle()
            } label: {
                Image(systemName: "plus.square")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 30)
                    .foregroundColor(Color("text_black"))
                    .frame(width: 50, height: 50)
                
            }
            .sheet(isPresented: $addViewPresented, content: {
                AddItemView(addItemViewPresented: $addViewPresented)
            })
            
            if items.count > 0{
                ScrollView(){
                    VStack(spacing:20){
                        ForEach(0..<items.count) { r in
                            if items[r].hidden == false {
                                Button {
                                    changeId = r
                                    changeViewPresented = true
                                } label: {
                                    ItemTileView(item: items[r])
                                }
                            }
                        }
                        Spacer()
                    }
                    .background(EmptyView()
                                    .sheet(isPresented: $changeViewPresented, content: {
                                        ChangeItemView(changeItemViewPresented: $changeViewPresented, item:items[changeId])
                                    })
                    )
                    
                }
            }
        }
        .padding(.init(top: 10, leading: 50, bottom: 10, trailing: 50))
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
