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
    // @State var catagorized = UserDefaults.standard.bool(forKey: "itemCatagorized")
    let catagorized = true
    
    let pButton:CGFloat = 0
    let sButton:CGFloat = 22
    let pButton2:CGFloat = 10
    let mButtons:CGFloat = 35
    let mButtonText:CGFloat = -3
    let fsSub:CGFloat = 10
    
    var body: some View {
        ZStack(alignment: .top){
            if !catagorized {
                if items.count == 0{
                    NoItemView(catagorized:catagorized)
                } else {
                    ItemViewAll(items: items, showArchive: showArchive)
                }
            } else {
                if items.count == 0{
                    NoItemView(catagorized:catagorized)
                } else {
                    ItemViewCatagorized(items: items, showArchive: showArchive)
                        .padding(.vertical,1)
                }
            }

                VStack{
                    Color.clear
                        .background(.ultraThinMaterial)
                        .frame(height:80)
                        .blur(radius: 10)
                    Spacer()
                    Color.clear
                        .background(.ultraThinMaterial)
                        .frame(height:60)
                        .blur(radius: 10)
                }
            threeButtons

        }
        // end whole view ZStack
        
        
    }
    var threeButtons: some View{
        HStack(alignment:.center,spacing: 20){
            FloatButton(systemName: "plus.square", sButton: sButton) {
                addViewPresented = true
            }
            .padding(.leading,20)
            .sheet(isPresented: $addViewPresented, content: {
                AddItemView(addItemViewPresented: $addViewPresented)
                    .environment(\.managedObjectContext,self.viewContext)
            })
            
            if catagorized{
                FloatButton(systemName: "plus.rectangle.on.folder", sButton: sButton+5) {
                    tagViewPresented = true
                }
                .sheet(isPresented: $tagViewPresented) {
                    EditTagView(editTagViewPresented: $tagViewPresented)
                        .environment(\.managedObjectContext,self.viewContext)
                }
            }
            
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
            }.frame(width: 100)
        }
        .frame(height:80)
        .padding(.top,pButton)
    }
}

//struct HabitView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
