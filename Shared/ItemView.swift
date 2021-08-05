//
//  HabitView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var addViewPresented = false
    @State var changeId = 0
    @State var showArchive = false
    
    let mHorizon:CGFloat = 30
    let mButton:CGFloat = 25
    let mButtonTiles:CGFloat = 30
    let sButton:CGFloat = 22
    let mTiles:CGFloat = 15
    let hTiles:CGFloat = 70
    let fsTitle:CGFloat = 18
    
    var body: some View {
        VStack(spacing:mButtonTiles){
            //MARK: Add Habit Button
            Button {
                addViewPresented.toggle()
            } label: {
                Image(systemName: "plus.square")
                    .resizable().scaledToFit()
                    .frame(width: sButton, height: sButton).padding(.top, mButton).foregroundColor(Color("text_black"))
                
            }
            .sheet(isPresented: $addViewPresented, content: {
                AddItemView(addItemViewPresented: $addViewPresented)
            })
            
            ScrollView(){
                VStack(spacing:mTiles){
                    //MARK: Habits Not Archived
                    
                    let itemFiltered = items.filter { item in
                        return item.hidden == false
                    }
                    ForEach(itemFiltered) { item in
                        ItemTileView(item: item,dumUpdate: propertiesModel.dumUpdate)
                            .frame(height:hTiles)
                    }
                    
                    //MARK: Habits Archived
                    let itemFiltered = items.filter { item in
                        return item.hidden == true
                    }
                    
                    if itemFiltered.count > 0 {
                        //MARK: Show archive button
                        Button {
                            showArchive.toggle()
                        } label: {
                            if showArchive{
                                Text("Hide archived habits...").font(.system(size: fsTitle)).foregroundColor(Color("text_black")).fontWeight(.light)
                            } else {
                                Text("Show \(itemFiltered.count) archived " + (itemFiltered.count == 1 ? "habit..." : "habits...")).font(.system(size: fsTitle)).foregroundColor(Color("text_black")).fontWeight(.light)
                            }
                        }.padding(.top,mButton)
                        
                        //MARK: Archived habits
                        if showArchive{
                            ForEach(itemFiltered) { item in
                                ItemTileView(item: item,dumUpdate: propertiesModel.dumUpdate)
                                    .frame(height:hTiles)
                            }
                        }
                    } else {
                        Text("No archived habits")
                            .font(.system(size: fsTitle))
                            .foregroundColor(Color("text_black"))
                            .fontWeight(.light)
                            .padding(.top,mButton)
                    }
                    Spacer()
                }
                
            }
        } // end whole view VStack
        .padding(.horizontal, mHorizon)
        
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
