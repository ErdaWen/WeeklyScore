//
//  ItemViewCatagorizedSection.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/17/21.
//

import SwiftUI

struct ItemViewCatagorizedSection: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var tag:Tag
    var items:[Item]
    var showArchive: Bool
    var dumUpdate:Bool
    
    @State var showItems = true
    
    let mTiles:CGFloat = 15
    let fsTitle:CGFloat = 18
    
    var body: some View {
        VStack(alignment: .leading,spacing:mTiles){
            
            
            HStack{
                Image(systemName: "chevron.down")
                    .resizable().scaledToFit()
                    .frame(width: 12)
                    .foregroundColor(Color(tag.colorName))
                    .rotationEffect(showItems ? Angle(degrees: 0) : Angle(degrees: -90))
                Text(tag.name)
                    .font(.system(size: fsTitle))
                    .fontWeight(.light)
                    .foregroundColor(Color(tag.colorName))
                Spacer()
            }
            .padding(.leading, 5)
            .onTapGesture {
                withAnimation(.default){
                showItems.toggle()
                }
            }
            
            if showItems {
                
                if items.count == 0{
                    HStack{
                        Spacer().frame(width:20)
                        Text("🌵 No habit in this catagory.")
                            .font(.system(size: 15))
                            .foregroundColor(Color("text_black"))
                            .fontWeight(.light)
                    }
                    
                } else {
                    let itemFiltered = items.filter { item in
                        return item.hidden == false
                    }
                    
                    if itemFiltered.count == 0 && !showArchive{
                        HStack{
                            Spacer().frame(width:20)
                            Text("📦 No active habit.")
                            .font(.system(size: 15))
                            .foregroundColor(Color("text_black"))
                            .fontWeight(.light)
                        }
                    }
                    
                    ForEach(itemFiltered) { item in
                        ItemTileView(item: item,dumUpdate: propertiesModel.dumUpdate)
                    }
                    
                    //MARK: Habits Archived
                    
                    if showArchive{
                        let itemFiltered = items.filter { item in
                            return item.hidden == true
                        }
                        
                        ForEach(itemFiltered) { item in
                            ItemTileView(item: item,dumUpdate: propertiesModel.dumUpdate)
                        }
        
                    }//end show archive
                }// end if no iten
   
            }//end show items
            
        }
    }
}

//struct ItemViewCatagorizedSection_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemViewCatagorizedSection()
//    }
//}
