//
//  ColorTagTileView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/27/21.
//

import SwiftUI


struct ColorTagTileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var propertiesModel:PropertiesModel
    
    var tag:Tag
    var dumUpdate:Bool
    
    @State var inputName = ""
    @State var showDeleteAlert = false
    @State var inputColorName = ""
    let mHor:CGFloat = 10
    let sColor:CGFloat = 30
    let rColor:CGFloat = 8
    let hField:CGFloat = 35
    let fsField:CGFloat = 15
    let colorNames = ["Red","Orange","Yellow","Green","Cyan","Blue","Magenta"]
    let colorSystemNames = ["tag_color_red","tag_color_orange","tag_color_yellow","tag_color_green","tag_color_cyan","tag_color_blue","tag_color_magenta"]


    func deleteTag(){
        viewContext.delete(tag)
        do{
            try viewContext.save()
            print("saved")
        } catch {
            print("Cannot delete tags")
            print(error)
        }
    }
    
    func saveTag(){
        tag.name = inputName
        tag.colorName = inputColorName
        do{
            try viewContext.save()
            propertiesModel.dumUpdate.toggle()
            print("saved")
        } catch {
            print("Cannot save tags")
            print(error)
        }
    }

    var body: some View {
        HStack(spacing:mHor){
            Menu {
                Picker("x",selection: $inputColorName) {
                    ForEach (0..<colorNames.count,id: \.self){ r in
                        Text(colorNames[r])
                            .tag(colorSystemNames[r])
                        
                    }
                }
            } label:{
                Image(systemName: "chevron.down")
                    .resizable().scaledToFit()
                    .foregroundColor(Color("background_white"))
                    .padding(10)
                    .frame(width:sColor, height:sColor)
                    .background(Color(tag.colorName))
                    .mask(RoundedRectangle(cornerRadius: rColor))
            }
            .onChange(of: inputColorName) { _ in
                saveTag()
            }

            ZStack {
                RoundedRectangle(cornerRadius: rColor)
                    .foregroundColor(Color(tag.colorName).opacity(0.1))
                    .frame(height:hField)
                TextField("Enter tag name",text:$inputName)
                    .font(.system(size: fsField))
                    .foregroundColor(Color(tag.colorName + "_text"))
                    .padding(.init(top: 3, leading: 5, bottom: 3, trailing: 5))
                    .onChange(of: inputName) { _ in
                        saveTag()
                    }
            }//end textfield ZStack
            Button {
                showDeleteAlert = true
            } label: {
                Image(systemName: "trash")
                    .resizable().scaledToFit()
                    .foregroundColor(Color("text_black"))
                    .frame(width:20)
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(title: Text("🤔 You Sure?"), message: Text("All habits will be deleted"), primaryButton: .default(Text("Keep"), action: {
                    showDeleteAlert = false
                }), secondaryButton: .default(Text("Delete"), action: {
                    deleteTag()
                }))
            }
        }//end single row hstack
        .onAppear(){
                inputName=tag.name
            inputColorName = tag.colorName
        }
    }
    
}

//struct ColorTagTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorTagTileView()
//    }
//}
