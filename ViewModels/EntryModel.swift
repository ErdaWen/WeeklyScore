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
        parseJason()
        // Update idmax
        if entries.count != 0{
            for r in 0...entries.count-1{
                if entries[r].id > idmax {
                    idmax = entries[r].id
                }
            }
        }
    }
    
    func parseJason(){
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
        }
    }
    
    func writeJson(){
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(entries)
            let pathString = Bundle.main.path(forResource: "entriesList", ofType: "json")
            if let path = pathString{
                let url=URL(fileURLWithPath: path)
                do{
                    try data.write(to: url)
                    do {
                        let savedData = try Data(contentsOf: url)
                        if let savedString = String(data: savedData, encoding: .utf8){
                            print("New Entry Json = " + savedString)
                        }
                    } catch {
                        print(error)
                    }
                    
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    // Manually update change for two things:
    // 1. toggle the self.refresh to refresh the views
    // 2. write to Json
    func updateChange() {
        refresh.toggle()
        writeJson()
    }
    
    // Add a new entry
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
        updateChange()
    }
    
    func deleteEntry (indexing: Int){
        // Alway after changing the completion of the corresponding habit
        if entries[indexing].id == idmax {
            idmax = idmax - 1
        }
        entries.remove(at: indexing)
        updateChange()
    }
    
    func deleteAllEntryRelated (deletedHabitId:Int){
        if entries.count > 0 {
            for entryIndex in (0...entries.count-1).reversed() {
                if entries[entryIndex].habitid == deletedHabitId {
                    deleteEntry(indexing: entryIndex)
                }
            }
        }
    }
    
    // Print time in certain format
    func printTime(inputTime:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return (formatter.string(from: inputTime))
    }
}
