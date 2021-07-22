//
//  WholeModel.swift
//  WeeklyScore
//
//  Created by Erda Wen on 7/20/21.
//

import Foundation

class InitializerModel: ObservableObject{
    init() {
        checkLoadedData()
    }
    
    func checkLoadedData() {
        let status = UserDefaults.standard.bool(forKey: Constants.isDataPreloaded)
        if status == false {
            preLoadData()
        }
    }
    
    func preLoadData() {
        
    }
}
