//
//  Cell.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//

import SwiftUI
import Foundation

// 字体颜色分类
enum FontColor: Codable {
    case known      // 正常已知
    case correct    // 填写正确
    case wrong      // 填写错误
}

// 背景颜色分类
enum BackgroundColor: Codable {
    case blank          // 无背景色
    case highLight      // 连带选择
    case selected       // 被选择
}

// 展示方式
enum CellState: Codable {
    case normal         // 正常现象
    case note           // 笔记模式
}

// 小方块四个坐标位置
struct Postion: Codable {
    let startX: CGFloat
    let startY: CGFloat
    let endX: CGFloat
    let endY: CGFloat
}

struct Cell: Codable {
    //var id = UUID()
    let x: Int
    let y: Int
    var targetValue: Int
    var fillValue: Int
    var postion: Postion?
    var isCanFilled = true  // 是否可以被填入
    
    var fontColor: FontColor = .known
    
    var backgroundColor: BackgroundColor = .blank
    
    var cellState: CellState = .normal
    var noteArray: [Bool] = [Bool](repeating: false, count: 9)
    
    init(x: Int, y: Int, targetValue: Int, fillValue: Int) {
        self.x = x
        self.y = y
        self.targetValue = targetValue
        self.fillValue = fillValue
        if targetValue == fillValue { isCanFilled = false }
    }
    
    mutating func setFillValue(_ fillValue: Int) {
        self.fillValue = fillValue
    }
    
    mutating func setTargetValue(_ targetValue: Int) {
        self.targetValue = targetValue
    }
}

// FontColorPart
extension Cell {
    mutating func fontKnown() {
        self.fontColor = .known
    }
   
    mutating func fontCorrect() {
        self.fontColor = .correct
    }
   
    mutating func fontWrong() {
        self.fontColor = .wrong
    }
   
}

// BackgroundColor
extension Cell {
    mutating func colorBlank() {
        self.backgroundColor = .blank
    }
   
    mutating func colorHighLight() {
        self.backgroundColor = .highLight
    }
   
    mutating func colorSelected() {
        self.backgroundColor = .selected
    }
}

// Postion
extension Cell {
    mutating func setCellPostion(_ postion: Postion) {
        self.postion = postion
    }
}

// Note Part
extension Cell {
    mutating func normalState() {
        self.cellState = .normal
    }
    
    mutating func noteState() {
        self.cellState = .note
    }
    
    mutating func addNumForNote(_ num: Int) {
        self.noteArray[num-1] = true
    }
    
    mutating func subNumForNote(_ num: Int) {
        self.noteArray[num-1] = false
    }
    
    mutating func clearNoteArray() {
        self.noteArray = [Bool](repeating: false, count: 9)
    }
    
    func isNoteExist(_ num: Int) -> Bool {
        return noteArray[num-1] == true
    }
}
