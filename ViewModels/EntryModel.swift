//
//  EntryModel.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import Foundation

class EntryModel: ObservableObject{
    @Published var entries = [Entry]()
    @Published var refresh = true
    // Keep the max id for adding new schedule
    var idmax = 0
    
    init(){
        // String path
        let pathString = Bundle.main.path(forResource: "entriesList", ofType: "json")
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
                    let entryData = try decoder.decode([Entry].self, from: data)
                    // MARK: Assigned data
                    entries = entryData
                } catch {
                    print(error)
                }
            } catch {
                print (error)
            }
            // Update idmax
            if entries.count != 0{
                for r in 0...entries.count-1{
                    if entries[r].id > idmax {
                        idmax = entries[r].id
                    }
                }
            }
        }
    }
    
    func addEntry (inHabitid:Int,inScore:Int,inBeginTime:Date,inEndTime:Date,inHidden:Bool){
        idmax += 1
        let newEntry = Entry()
        newEntry.id = idmax
        newEntry.habitid = inHabitid
        newEntry.score = inScore
        newEntry.beginTime = inBeginTime
        newEntry.endTime = inEndTime
        newEntry.hidden = inHidden
        entries.append(newEntry)
    }
    
    // Print time in certain format
    func printTime(inputTime:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return (formatter.string(from: inputTime))
    }
}
