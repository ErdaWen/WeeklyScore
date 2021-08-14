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
    @State var showArchive = UserDefaults.standard.bool(forKey: "showArchivedItem")
    @State var catagorized = UserDefaults.standard.bool(forKey: "itemCatagorized")
    
    let pButton:CGFloat = 20
    let sButton:CGFloat = 22
    let pButton2:CGFloat = 10
    let mButtons:CGFloat = 35
    let mButtonText:CGFloat = -3
    let fsSub:CGFloat = 12
    
    var body: some View {
        ZStack(alignment: .top){
            //MARK: Add Habit Button
            if !catagorized {
                ItemViewAll(items: items, showArchive: showArchive)
            } else {
                
            }
            //MARK: Add habit button
                //MARK:Buttons
                FloatButton(systemName: "plus.square", sButton: sButton) {
                    addViewPresented = true
                }
                .padding(.top,pButton)
                .sheet(isPresented: $addViewPresented, content: {
                    AddItemView(addItemViewPresented: $addViewPresented)
                })
            //MARK: Archive and tag button
            
            VStack{
                Spacer()
                HStack(spacing:mButtons){
                    Spacer()
                    //MARK: Archive button
                    HStack(alignment: .center, spacing: mButtonText){
                        FloatButton(systemName: "archivebox", sButton: sButton) {
                            showArchive.toggle()
                            UserDefaults.standard.set(showArchive, forKey: "showArchivedItem")
                        }
                        Text( showArchive ? "Hide\nArchived" : "Show\nArchived")
                            .font(.system(size: fsSub))
                            .fontWeight(.light)
                            .foregroundColor(Color("text_black"))
                            .multilineTextAlignment(.leading)

                    }
                    //MARK: Tag Button
                    HStack(alignment: .center, spacing: mButtonText){
                        FloatButton(systemName: catagorized ? "tag.slash" : "tag", sButton: sButton) {
                                catagorized.toggle()
                                UserDefaults.standard.set(catagorized, forKey: "itemCatagorized")
                            }
                        

                        Text( catagorized ? "By\nDate" : "By\nTag")
                            .font(.system(size: fsSub))
                            .fontWeight(.light)
                            .foregroundColor(Color("text_black"))
                            .multilineTextAlignment(.leading)
                            .frame(width:30)

                    }
                    Spacer()
                }
            } .padding(.bottom,pButton2)
            
            
        }
        // end whole view ZStack
        
        
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
