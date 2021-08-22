//
//  Theme.swift
//  WeeklyScore
//
//  Created by Erda Wen on 8/21/21.
//

import Foundation
import SwiftUI

class Theme {
    static func navigationBarColors(background : UIColor?,
       titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        
//        navigationAppearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16, weight: .light)]
//        navigationAppearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 16, weight: .light)]
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black, .font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black, .font: UIFont.systemFont(ofSize: 25, weight: .semibold)]

       
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance

        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}
