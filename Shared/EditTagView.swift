//
//  EditTagView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/17/21.
//

import SwiftUI

struct EditTagView: View {
    @AppStorage("nightMode") private var nightMode = true

    @EnvironmentObject var propertiesModel:PropertiesModel
    @Binding var editTagViewPresented:Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    @State var disableSave = false
    
    let mNavBar:CGFloat = 25
    let fsNavBar:CGFloat = 20
    let mVer:CGFloat = 22
    let sButton:CGFloat = 22
    let pButton:CGFloat = 0

    func genNewTag(){
        let newTag = Tag(context: viewContext)
        newTag.id = UUID()
        newTag.lastUse = Date()
        newTag.name = "Unamed Catagory"
        newTag.colorName = "tag_color_red"
        do{
            try viewContext.save()
            print("New tag generated")
        } catch {
            print("Cannot generate new tag")
            print(error)
        }
    }
    
    var body: some View {
        VStack{
            //MARK: Navigation bar
            
            HStack{
                Button {
                    editTagViewPresented = false
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable().scaledToFit()
                        .foregroundColor(Color("text_black"))
                        .frame(height:25)
                }
                Spacer()
                Text("Manage Catagories")
                    .font(.system(size: fsNavBar))
                Spacer()
                Spacer().frame(width:30)
                
            }.padding(mNavBar)
            
            //MARK: Contents
            ScrollView{
                VStack(spacing:mVer){
                    
                    FloatButton(systemName: "plus.square", sButton: sButton) {
                        genNewTag()
                    }
                    .padding(.top,pButton)
                    
                    ForEach(tags){ tag in
                        ColorTagTileView(tag: tag,dumUpdate:propertiesModel.dumUpdate)
                    }
                    
                }// end Vstack
                .padding(.init(top: 0, leading: 40, bottom: 10, trailing: 40))
            }// end scroll view
            .preferredColorScheme(nightMode ? nil : .light)

        }
    }
}

//struct EditTagView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTagView()
//    }
//}
