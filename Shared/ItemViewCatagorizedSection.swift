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
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//struct ItemViewCatagorizedSection_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemViewCatagorizedSection()
//    }
//}
