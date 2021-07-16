//
//  HabitModel.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import Foundation

class HabitModel: ObservableObject{
    @Published var habits = [Habit]()
    @Published var refresh = true
    // keep the maximum id so added habits can take the next Int
    var idmax = 0
    // idIndexing[x] returns the index in the array of the habit with id=x
    var idIndexing = [Int?]()
    // activeIdpos records the active habit in add schedule view
    var activeIdpos = 0
    
    init(){
        parseJson()
        // Update idmax
        if habits.count != 0{
            for r in 0...habits.count-1{
                if habits[r].id > idmax {
                    idmax = habits[r].id
                }
            }
        }
        // Update indexing
        updateIdIndexing()
    }
    
    func parseJson(){
        // String path
        let pathString = Bundle.main.path(forResource: "habitsList", ofType: "json")
        if let path = pathString{
            // URL
            let url=URL(fileURLWithPath: path)
            // Data Obj
            do{
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                // Parse json
                do{
                    let habitData = try decoder.decode([Habit].self, from: data)
                    // MARK: Assigned data
                    habits = habitData
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
            let data = try encoder.encode(habits)
            let pathString = Bundle.main.path(forResource: "habitsList", ofType: "json")
            if let path = pathString{
                let url=URL(fileURLWithPath: path)
                do{
                    try data.write(to: url)
                    do {
                        let savedData = try Data(contentsOf: url)
                        if let savedString = String(data: savedData, encoding: .utf8){
                            print("New Habit Json = " + savedString)
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
    
    func addHabit (inDurationbased:Bool, inTitleIcon:String, inTitle:String, inDefaultScore:Int, inColorTag:Int, inHidden:Bool){
        idmax += 1
        let newHabit = Habit()
        newHabit.id = idmax
        newHabit.durationBased = inDurationbased
        newHabit.titleIcon = inTitleIcon
        newHabit.title = inTitle
        newHabit.defaultScore = inDefaultScore
        newHabit.colorTag = inColorTag
        newHabit.hidden = inHidden
        habits.append(newHabit)
        updateIdIndexing()
        updateChange()
    }
    
    func updateIdIndexing (){
        // refresh the idIndexing when initializing, adding or deleting habits.
        idIndexing = Array(repeating:nil, count:idmax+1)
        if habits.count != 0 {
            for r in 0...habits.count-1{
                idIndexing[habits[r].id] = r
            }
        }
        // Triggering this function also means a change of habit number,
        // so the activeIdpos should also be refreshed
        activeIdpos = habits.count-1
        // idmax needs no change since it's taken care inside intitalizer, addHabit or deletHabit
        // Can be distributed to each function. When addHabit or deleteHabit, only one element
        // needs to be changed.
    }
    
    func deleteHabit(indexing:Int){
        // delete all entries before triggering this function
        if habits[indexing].id == idmax {
            idmax = idmax - 1
        }
        habits.remove(at: indexing)
        updateIdIndexing()
        updateChange()
    }
    
}
