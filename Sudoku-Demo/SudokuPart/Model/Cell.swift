//
//  Cell.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//

import SwiftUI
import Foundation

// 字体颜色分类
enum CellFontColor: Codable {
    case known      // 正常已知
    case correct    // 填写正确
    case wrong      // 填写错误
}

// 背景颜色分类
enum CellColor: Codable {
    case blank          // 无背景色
    case highLight      // 连带选择
    case selected       // 被选择
}

// 展示方式
enum CellState: Codable {
    case normal         // 正常现象
    case note           // 笔记模式
}

struct Cell: Codable {
    //var id = UUID()
    let x: Int
    let y: Int
    
    private(set) var rect: CGRect?
    /// cell目标数值
    private(set) var targetValue: Int
    /// cell填入数值
    private(set) var fillValue: Int
    /// cell能否填入
    private(set) var isCanFill: Bool
    
    /// cell填写状态
    private(set) var state: CellState = .normal
    /// cell字体颜色
    private(set) var fontColor: CellFontColor = .known
    /// cell背景颜色
    private(set) var cellColor: CellColor = .blank
    /// 笔记数组
    private var noteArray: [Bool]
    
    init(x: Int, y: Int) {
        self.targetValue = 0
        self.fillValue = 0
        self.isCanFill = false
        self.x = x
        self.y = y
        self.noteArray = [Bool](repeating: false, count: 9)
    }
    
    public mutating func resetTarget(_ target: Int, _ fill: Int) {
        // 重新设值
        targetValue = target
        fillValue = fill
        isCanFill = targetValue != fillValue
        // 更新状态
        state = .normal
        cellColor = .blank
        if !isCanFill {
            fontColor = .known
        }
    }
}

extension Cell {
    /// 执行填写操作
    /// - Parameter fill: 填入数值
    /// - Returns: 是否填入正确
    @discardableResult
    public mutating func fillAction(_ fill: Int) -> Bool {
        // 清空笔记恢复正常模式
        self.switchToNormal()
        // 判断状态
        let isCorrect = targetValue == fill
        let fontColor: CellFontColor = isCorrect ? .correct : .wrong
        // 更新状态
        self.fillValue = fill
        self.fontColor = fontColor
        
        return isCorrect
    }
}

extension Cell {
    public mutating func updateFillValue(_ value: Int) {
        self.fillValue = value
    }
    
    public mutating func updateState(_ cellState: CellState) {
        self.state = cellState
    }
    
    public mutating func updateRect(_ rect: CGRect) {
        self.rect = rect
    }
    
    public mutating func updateCellColor(_ color: CellColor) {
        self.cellColor = color
    }
    
    public mutating func updateFontColor(_ color: CellFontColor) {
        self.fontColor = color
    }
}

// Note Part
extension Cell {
    /// 恢复正常模式
    private mutating func switchToNormal() {
        state = .normal
        clearNoteArray()
    }
    
    public mutating func addNumForNote(_ num: Int) {
        self.noteArray[num-1] = true
    }
    
    public mutating func subNumForNote(_ num: Int) {
        self.noteArray[num-1] = false
    }
    
    public mutating func clearNoteArray() {
        self.noteArray = [Bool](repeating: false, count: 9)
    }
    
    public func isNoteExist(_ num: Int) -> Bool {
        return noteArray[num-1] == true
    }
}
