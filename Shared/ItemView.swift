//
//  HabitView.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import SwiftUI

struct ItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "lastUse", ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var addViewPresented = false
    @State var changeViewPresented = false
    
    var body: some View {
        VStack(spacing:30){
            Button {
                addViewPresented.toggle()
            } label: {
                Image(systemName: "plus.square")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 30)
                    .foregroundColor(Color("text_black"))
                    .frame(width: 50, height: 50)
                
            }
            .sheet(isPresented: $addViewPresented, content: {
                AddItemView(addItemViewPresented: $addViewPresented)
            })
            
            if items.count > 0{
                ScrollView(){
                    LazyVStack(spacing:20){
                        ForEach(0..<items.count) { r in
                            if items[r].hidden == false {
                                Button {
                                    changeViewPresented = true
                                } label: {
                                    ItemTileView(item: items[r])
                                }
                                .sheet(isPresented: $changeViewPresented, content: {
                                    //ChangeItemView(changeItemViewPresented: $changeViewPresented, item:items[r])
                                    Text("\(r)")
                                })
                            }
                        }
                        
//                        ForEach(items) { item in
//                            if item.hidden == false {
//                                Button {
//                                    changeViewPresented = true
//                                } label: {
//                                    ItemTileView(item: item)
//                                }
//                                .sheet(isPresented: $changeViewPresented, content: {
//                                    ChangeItemView(changeItemViewPresented: $changeViewPresented, item:item)
//                                })
//                                //.sheet(isPresented: $changeViewPresented, content: {
//                                //    ChangeItemView(changeItemViewPresented: $changeViewPresented, item:item)
//                                //})
//                            }
//                        }
                        Spacer()
                        
                        //                        HStack{
                        //                            Rectangle().frame(width: 40, height: 40).foregroundColor(Color(items[r].tags.colorName)).cornerRadius(8.0)
                        //                            Button(items[r].titleIcon + items[r].title) {
                        //                                changeViewPresented = true
                        //                            }.sheet(isPresented: $changeViewPresented, content: {
                        //                                ChangeItemView(changeItemViewPresented: $changeViewPresented, item:items[r])
                        //                            })
                        //                            if items[r].durationBased {
                        //                                Text("Total \(items[r].minutesTotal) minutes")
                        //                            } else {
                        //                                Text("\(items[r].checkedTotal) times hited")
                        //                            }
                        //                            Text(String(items[r].scoreTotal))
                        //                        }
                    }
                }
                
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
        }
        .padding(.init(top: 10, leading: 50, bottom: 10, trailing: 50))
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
