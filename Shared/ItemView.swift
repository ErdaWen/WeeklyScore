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
    @State var showArchive = false
    
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
                    .frame(width: 54, height: 54)
                
            }
            .sheet(isPresented: $addViewPresented, content: {
                AddItemView(addItemViewPresented: $addViewPresented)
            })
                        
            ScrollView(){
                VStack(spacing:20){
                    // Habits
                    ForEach(items) { item in
                        if !item.hidden {
                            Button {
                                changeId = items.firstIndex(where: {$0.id == item.id}) ?? 0
                                changeViewPresented = true
                            } label: {
                                ItemTileView(item: item)
                            }
                        }
                    }
                    //MARK: Show archive button
                    Button {
                        showArchive.toggle()
                    } label: {
                        if showArchive{
                            Text("Hide archived habits...")
                                .font(.system(size: 18))
                                .foregroundColor(Color("text_black"))
                                .fontWeight(.light)
                        } else {
                            Text("Show archived habits...")
                                .font(.system(size: 18))
                                .foregroundColor(Color("text_black"))
                                .fontWeight(.light)
                        }
                    }.padding(.top,20)
                    //MARK: Archived habits
                    if showArchive{
                        ForEach(items) { item in
                            if item.hidden {
                                Button {
                                    changeId = items.firstIndex(where: {$0.id == item.id}) ?? 0
                                    changeViewPresented = true
                                } label: {
                                    ItemTileView(item: item)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .sheet(isPresented:$changeViewPresented, content: {
                    ChangeItemView(changeItemViewPresented: $changeViewPresented, item:items[changeId])
                })
            }
        }
        .padding(.init(top: 10, leading: 35, bottom: 10, trailing: 35))
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
