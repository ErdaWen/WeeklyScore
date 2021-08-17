//
//  ItemViewCatagorized.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/17/21.
//

import SwiftUI

struct ItemViewCatagorized: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    var items:FetchedResults<Item>
    var showArchive: Bool
    
    let topSpace:CGFloat = 65
    let mHorizon:CGFloat = 30
    let mSections:CGFloat = 10
    
    var body: some View {
        ScrollView{
            VStack(spacing:mSections){
                Spacer()
                    .frame(height:topSpace)
                
                ForEach(tags){tag in
                    let itemFiltered = items.filter { item in
                        return item.tags == tag
                    }
                    
                    ItemViewCatagorizedSection(tag:tag,items:itemFiltered,showArchive:showArchive)
                    
                }
                
                Spacer()
                    .frame(height:topSpace)
                Spacer()
            }.padding(.horizontal, mHorizon)
        }
        
    }
}
//
//struct ItemViewCatagorized_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemViewCatagorized()
//    }
//}
