//
//  EditTagView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/17/21.
//

import SwiftUI

struct EditTagView: View {
    @Binding var editTagViewPresented:Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    @State var names:[String] = []
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//struct EditTagView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTagView()
//    }
//}
