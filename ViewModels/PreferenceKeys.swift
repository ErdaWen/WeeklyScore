//
//  PreferenceKeys.swift
//  WeeklyScore (iOS)
//
//  Created by Erda Wen on 9/25/22.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue:CGFloat = 250
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
