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
    @State var tagViewPresented = false
    
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
                ItemViewCatagorized(items: items, showArchive: showArchive)
            }
            //MARK: Add habit button
                //MARK:Buttons
            HStack(spacing: 20){
                FloatButton(systemName: "plus.square", sButton: sButton) {
                    addViewPresented = true
                }
                .padding(.top,pButton)
                .sheet(isPresented: $addViewPresented, content: {
                    AddItemView(addItemViewPresented: $addViewPresented)
                        .environment(\.managedObjectContext,self.viewContext)
                })
                
                if catagorized{
                    FloatButton(systemName: "folder", sButton: sButton) {
                        tagViewPresented = true
                    }
                    .padding(.top,pButton)
                    .sheet(isPresented: $tagViewPresented) {
                        EditTagView(editTagViewPresented: $tagViewPresented)
                            .environment(\.managedObjectContext,self.viewContext)
                    }
                }
            }.frame(height:80)
            
            //MARK: Archive and tag button
            VStack{
                Spacer()
                ZStack(){
                    //MARK: Background
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color("background_white"),Color("background_white").opacity(0.8),Color("background_white").opacity(0)]), startPoint: .bottom, endPoint: .top))
                    
                    //MARK: Buttons on top
                    HStack(spacing:0){
                        Spacer()
                        //MARK: Archive button
                        HStack(alignment: .center, spacing: mButtonText){
                            FloatButton(systemName: showArchive ? "archivebox.fill" : "archivebox", sButton: sButton) {
                                withAnimation(.default){
                                showArchive.toggle()
                                }
                                UserDefaults.standard.set(showArchive, forKey: "showArchivedItem")
                            }
                            Text( showArchive ? "Hide\nArchived" : "Show\nArchived")
                                .font(.system(size: fsSub))
                                .fontWeight(.light)
                                .foregroundColor(Color("text_black"))
                                .multilineTextAlignment(.leading)

                        }
                        Spacer()
                        //MARK: Tag Button
                        HStack(alignment: .center, spacing: mButtonText){
                            FloatButton(systemName: catagorized ? "folder.fill" : "folder", sButton: sButton) {
                                withAnimation(.default){
                                    catagorized.toggle()
                                }
                                    UserDefaults.standard.set(catagorized, forKey: "itemCatagorized")
                                }
                            

                            Text( catagorized ? "Hide\nCatagory" : "Show\nCatagory")
                                .font(.system(size: fsSub))
                                .fontWeight(.light)
                                .foregroundColor(Color("text_black"))
                                .multilineTextAlignment(.leading)
                                .frame(width:70)

                        }
                        Spacer()
                    }
                }.frame(height:45)//end bottom button Zstack
        
            } //end bottom button Vstack
            
            
        }
        // end whole view ZStack
        
        
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
