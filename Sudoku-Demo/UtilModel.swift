//
//  UtilModel.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/15.
//

import Foundation
import SwiftUI

extension View {
    func cellAdaptive() -> some View {
        self.modifier(AdaptiveFrameSudokuCell())
    }
    
    func fillButtonAdaptive() -> some View {
        self.modifier(AdaptiveFrameFillNum())
    }
    
    func functionButtonAdaptive() -> some View {
        self.modifier(AdaptiveFrameFunctionButton())
    }
    
    func noteAdaptive() -> some View {
        self.modifier(AdaptiveFrameNote())
    }
}

// 自适应尺寸大小 cell
fileprivate struct AdaptiveFrameSudokuCell: ViewModifier {
    let screenWidth = UIScreen.main.bounds.width
    func body(content: Content) -> some View {
        content
            .font(.system(size: screenWidth/11, weight: .light, design: .default))
            .frame(width: screenWidth/10, height: screenWidth/10)
    }
}

// 自适应尺寸大小 fillButton
fileprivate struct AdaptiveFrameFillNum: ViewModifier {
    let screenWidth = UIScreen.main.bounds.width
    func body(content: Content) -> some View {
        content
            .font(.system(size: screenWidth/13, weight: .light, design: .default))
            .frame(width: screenWidth/12, height: screenWidth/12)
            .overlay(
                RoundedRectangle(cornerRadius: screenWidth/50)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

fileprivate struct AdaptiveFrameFunctionButton: ViewModifier {
    let screenWidth = UIScreen.main.bounds.width
    func body(content: Content) -> some View {
        content
            .frame(width: screenWidth/15, height: screenWidth/15)
    }
}

// 自适应尺寸大小 note
fileprivate struct AdaptiveFrameNote: ViewModifier {
    let screenWidth = UIScreen.main.bounds.width
    func body(content: Content) -> some View {
        content
            .font(.system(size: screenWidth/35, weight: .light, design: .default))
            .frame(width: screenWidth/36, height: screenWidth/36)
            .foregroundColor(.gray)
            //.frame(width: screenWidth/90, height: screenWidth/90)
    }
}
