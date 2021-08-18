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
                showItems.toggle()
            }
            
            
            .animation(.default)
            
            if showItems {
                let itemFiltered = items.filter { item in
                    return item.hidden == false
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
            }//end show items
            
        }
    }
}

//struct ItemViewCatagorizedSection_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemViewCatagorizedSection()
//    }
//}
