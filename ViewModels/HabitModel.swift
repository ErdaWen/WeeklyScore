//
//  HabitModel.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/4/21.
//

import Foundation

class HabitModel{
    var habits_Db = [Habit_Db]()
    init(){
        // String path
        let pathString = Bundle.main.path(forResource: "habits_DbList", ofType: "json")
        if let path = pathString{
            // URL
            let url=URL(fileURLWithPath: path)
            // Data Obj
            do{
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                // Parse json
                do{
                    let habitData = try decoder.decode([Habit_Db].self, from: data)
                    for r in habitData{
                        r.id = UUID()
                    }
                    // MARK: Assigned data
                    habits_Db = habitData
                } catch {
                    print(error)
                }
            } catch {
                print (error)
            }
            
        }
    }
}
