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
    var idmax = 0
    var idIndexing = [Int?]()
    var activeId:Int
    
    init(){
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
        activeId = 0
        if habits.count != 0{
            for r in 0...habits.count-1{
                if habits[r].id > idmax {
                    idmax = habits[r].id
                }
            }
            activeId = idmax
        }
        updateIdIndexing()
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
    }
    
    func updateIdIndexing (){
        idIndexing = Array(repeating:nil, count:idmax+1)
        if habits.count != 0 {
            for r in 0...habits.count-1{
                idIndexing[habits[r].id] = r
            }
        }
    }

}
