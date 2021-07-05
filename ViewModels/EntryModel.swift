//
//  EntryModel.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import Foundation

class EntryModel{
    var entries = [Entry_Db]()
    init(){
        // String path
        let pathString = Bundle.main.path(forResource: "entries_DbList", ofType: "json")
        if let path = pathString{
            // URL
            let url=URL(fileURLWithPath: path)
            // Data Obj
            do{
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                // Parse json
                do{
                    let entryData = try decoder.decode([Entry_Db].self, from: data)
                    for r in entryData{
                        r.id = UUID()
                    }
                    // MARK: Assigned data
                    entries = entryData
                } catch {
                    print(error)
                }
            } catch {
                print (error)
            }
            
        }
    }
}
