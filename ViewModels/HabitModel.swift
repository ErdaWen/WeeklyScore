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
        parseJason()
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
    
    func parseJason(){
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
        // Write to json
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
    
    func deletehabit(){
        // depends on whether it's idmax
        // update indexing
        // Write to json
        // followed by deleted all entries
    }
    
}