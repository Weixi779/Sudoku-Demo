//
//  ColorController.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//

import Foundation
import SwiftUI



enum ColorSet {
    case font(FontColor), background(CellColor)
}

struct ThemeData {
    let knownColor: Color
    let correctColor: Color
    let wrongColor: Color
    let blankColor: Color
    let hightLightColor: Color
    let selectedColor: Color
    
    init(_ knownColor: Color, _ correctColor: Color, _ wrongColor: Color, _ blankColor: Color, _ hightLightColor: Color, _ selectedColor: Color) {
        self.knownColor = knownColor
        self.correctColor = correctColor
        self.wrongColor = wrongColor
        self.blankColor = blankColor
        self.hightLightColor = hightLightColor
        self.selectedColor = selectedColor
    }
}


struct ColorController {
    var theme: ThemeData
    
    init() {
        self.theme = ColorController.classic
    }
    
    func getColor( _ value: ColorSet) -> Color {
        switch value {
        case .font(let fontColor):
            switch fontColor {
            case .known: return theme.knownColor
            case .correct: return theme.correctColor
            case .wrong: return theme.wrongColor
            }
        case .background(let backgroundColor):
            switch backgroundColor {
            case .blank: return theme.blankColor
            case .highLight: return theme.hightLightColor
            case .selected: return theme.selectedColor
            }
        }
    }
    
    static let classic = ThemeData(.black, .blue, .red, .white, Color("Deepen").opacity(0.2), Color("Deepen").opacity(0.5))
}
