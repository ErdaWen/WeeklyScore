//
//  EditTagView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/17/21.
//

import SwiftUI

struct EditTagView: View {
    @EnvironmentObject var propertiesModel:PropertiesModel
    @Binding var editTagViewPresented:Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    @State var inputNames = ["","","","","","",""]
    @State var disableSave = false
    
    let rColor:CGFloat = 8
    let mNavBar:CGFloat = 25
    let fsNavBar:CGFloat = 20
    let fsField:CGFloat = 18
    let mVer:CGFloat = 22
    let mHor:CGFloat = 10
    let hField:CGFloat = 35
    let sColor:CGFloat = 25
    
    func saveTags(){
        for r in 0...6{
            tags[r].name = inputNames[r]
        }
        
        do{
            try viewContext.save()
            propertiesModel.dumUpdate.toggle()
            print("saved")
            editTagViewPresented = false
        } catch {
            print("Cannot save tags")
            print(error)
        }
    }
    
    var body: some View {
        VStack{
            //MARK: Navigation bar
            
            HStack{
                Button(action:{ editTagViewPresented = false}
                       , label: {
                        Text("Cancel")
                            .foregroundColor(Color("text_red")).font(.system(size: fsNavBar))
                       })
                
                Spacer()
                //MARK: Title
                Text("Rename Tags")
                    .font(.system(size: fsNavBar))
                Spacer()
                Button(action:{
                    saveTags()
                }, label: {
                    Text("  Save")
                        .foregroundColor(disableSave ? Color("text_black").opacity(0.5) : Color("text_blue")).font(.system(size: fsNavBar)).fontWeight(.semibold)

                }).disabled(disableSave)
                
            }.padding(mNavBar)
            
            //MARK: Contents
            ScrollView{
                VStack(spacing:mVer){
                    ForEach(0...6,id: \.self){ r in
                        HStack(spacing:mHor){
                            RoundedRectangle(cornerRadius: rColor)
                                .foregroundColor(Color(tags[r].colorName))
                                .frame(width:sColor, height:sColor)
                            ZStack {
                                RoundedRectangle(cornerRadius: rColor)
                                    .foregroundColor(Color(tags[r].colorName).opacity(0.1))
                                    .frame(height:hField)
                                TextField("Enter tag name",text:$inputNames[r])
                                    .font(.system(size: fsField))
                                    .foregroundColor(Color(tags[r].colorName + "_text"))
                                    .padding(.init(top: 3, leading: 5, bottom: 3, trailing: 5))
                                    .onChange(of: inputNames[r]) { _ in
                                        disableSave = false
                                        for r in 0...6{
                                            if inputNames[r].isEmpty {
                                                disableSave = true
                                            }
                                        }
                                    }
                            }//end textfield ZStack
                        }//end single row hstack
                    }// end 0...6 interation
                }// end Vstack
                .padding(.init(top: 0, leading: 40, bottom: 10, trailing: 40))
            }// end scroll view
            .onAppear(){
                for r in 0...6{
                    inputNames[r]=tags[r].name
                }
            }
        }
    }
}

//struct EditTagView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTagView()
//    }
//}
