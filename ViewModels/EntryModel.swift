//
//  EntryModel.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import Foundation

class EntryModel{
    var entries_Db = [Entry_Db]()
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
                decoder.dateDecodingStrategy = .iso8601
                // Parse json
                do{
                    let entryData = try decoder.decode([Entry_Db].self, from: data)
                    for r in entryData{
                        r.id = UUID()
                    }
                    // MARK: Assigned data
                    entries_Db = entryData
                } catch {
                    print(error)
                }
            } catch {
                print (error)
            }
            
        }
    }
    
    func printTime(inputTime:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return (formatter.string(from: inputTime))
    }
}
