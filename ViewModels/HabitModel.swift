//
//  HabitModel.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import Foundation

class HabitModel: ObservableObject{
    @Published var habits = [Habit]()
    
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
                    for r in habitData{
                        r.id = UUID()
                    }
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
        let newHabit = Habit()
        newHabit.id = UUID()
        newHabit.durationBased = inDurationbased
        newHabit.titleIcon = inTitleIcon
        newHabit.title = inTitle
        newHabit.defaultScore = inDefaultScore
        newHabit.colorTag = inColorTag
        newHabit.hidden = inHidden
        habits.append(newHabit)
    }
}
