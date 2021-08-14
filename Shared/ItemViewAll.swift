//
//  ItemViewAll.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/13/21.
//

import SwiftUI

struct ItemViewAll: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    
    var items:FetchedResults<Item>
    var showArchive: Bool
    
    let mTiles:CGFloat = 15
    let topSpace:CGFloat = 65
    let mHorizon:CGFloat = 30
    let fsTitle:CGFloat = 15
    
    
    var body: some View {
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
                        .padding(.horizontal, mHorizon)
                }
                
                //MARK: Habits Archived
                
                if showArchive{
                    let itemFiltered = items.filter { item in
                        return item.hidden == true
                    }
                    if itemFiltered.count > 0 {
                    ForEach(itemFiltered) { item in
                        ItemTileView(item: item,dumUpdate: propertiesModel.dumUpdate)
                            .padding(.horizontal, mHorizon)
                    }
                    } else {
                        Text("No archived habits")
                            .font(.system(size: fsTitle))
                            .foregroundColor(Color("text_black"))
                            .fontWeight(.light)
                            .animation(.default)
                    }
                    
                }
                Spacer()
                    .frame(height:topSpace)
                Spacer()
            }
        }
    }
}

//struct ItemViewAll_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemViewAll()
//    }
//}
