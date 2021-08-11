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
    let topSpace:CGFloat = 65
    let pButton:CGFloat = 20
    let mButton:CGFloat = 25
    let sButton:CGFloat = 22
    let mTiles:CGFloat = 15
    let hTiles:CGFloat = 45
    let fsTitle:CGFloat = 18
    
    var body: some View {
        ZStack(alignment: .top){
            //MARK: Add Habit Button
            VStack{
                ScrollView(){
                    VStack(spacing:mTiles){
                        Spacer()
                            .frame(height:topSpace)
                        //MARK: Habits Not Archived
                        
                        let itemFiltered = items.filter { item in
                            return item.hidden == false
                        }
                        ForEach(itemFiltered) { item in
                            ItemTileView(item: item,dumUpdate: propertiesModel.dumUpdate)
                                .frame(height:hTiles)
                                .padding(.horizontal, mHorizon)
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
                            }
                            .padding(.top,mButton)
                            
                            //MARK: Archived habits
                            if showArchive{
                                ForEach(itemFiltered) { item in
                                    ItemTileView(item: item,dumUpdate: propertiesModel.dumUpdate)
                                        .frame(height:hTiles)
                                        .padding(.horizontal, mHorizon)
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
                // end Scroll View
            }
            
            ZStack{
                //MARK:Buttons
                FloatButton(systemName: "plus.square", sButton: sButton) {
                    addViewPresented = true
                }
                .sheet(isPresented: $addViewPresented, content: {
                    AddItemView(addItemViewPresented: $addViewPresented)
                })
            } .padding(.top,pButton)

        }
        // end whole view ZStack
        
        
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
