//
//  UtilModel.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/15.
//

import Foundation
import SwiftUI

extension View {
    func adaptiveFrame() -> some View {
        self.modifier(AdaptiveFrameI())
    }
    
func fillButtonAdaptive() -> some View {
        self.modifier(AdaptiveFrameII())
    }
}

// 自适应尺寸大小 cell
fileprivate struct AdaptiveFrameI: ViewModifier {
    let screenWidth = UIScreen.main.bounds.width
    func body(content: Content) -> some View {
        content
            .font(.system(size: screenWidth/11, weight: .light, design: .default))
            .frame(width: screenWidth/10, height: screenWidth/10)
    }
}

// 自适应尺寸大小 fillButton
fileprivate struct AdaptiveFrameII: ViewModifier {
    let screenWidth = UIScreen.main.bounds.width
    func body(content: Content) -> some View {
        content
            .font(.system(size: screenWidth/13, weight: .light, design: .default))
            .frame(width: screenWidth/12, height: screenWidth/12)
            .cornerRadius(screenWidth/50)
    }
}
