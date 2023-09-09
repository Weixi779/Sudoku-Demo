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
enum cellColor: Codable {
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
    private var _targetValue: Int = 0
    private var _fillValue: Int = 0
    private var _isCanFilled = false  // 是否可以被填入
    
    private(set) var state: CellState = .normal
    private var _fontColor: FontColor = .known
    private(set) var backgroundColor: cellColor = .blank
    
    private var _noteArray: [Bool] = [Bool](repeating: false, count: 9)
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    mutating func resetCell(_ targetValue: Int, _ fillValue: Int) {
        setTargetValue(targetValue)
        setFillValue(fillValue)
        setCanFilledValue(targetValue != fillValue)
        self.state = .normal
    }
}

// - MARK: TargetValue Part
extension Cell {
    private(set) var targetValue: Int {
        get { return _targetValue }
        set { _targetValue = newValue }
    }
    mutating func setTargetValue(_ value: Int) {
        targetValue = value
    }
}

// - MARK: FillValue Part
extension Cell {
    private(set) var fillValue: Int {
        get { return _fillValue }
        set { _fillValue = newValue }
    }
    mutating func setFillValue(_ value: Int) {
        fillValue = value
    }
}

extension Cell {
    /// Cell是否可以填入,true为可填,false为不可填
    private(set) var isCanFilled: Bool {
        get { return _isCanFilled }
        set { _isCanFilled = newValue }
    }
    private mutating func setCanFilledValue(_ value: Bool) {
        isCanFilled = value
        if !isCanFilled {
            fontColor = .known
        }
    }
}

// FontColorPart
extension Cell {
    private(set) var fontColor: FontColor {
        get { return _fontColor }
        set { _fontColor = newValue }
    }
    mutating func fontKnown() {
        fontColor = .known
    }
   
    mutating func fontCorrect() {
        fontColor = .correct
    }
   
    mutating func fontWrong() {
        fontColor = .wrong
    }
   
}

extension Cell {
    mutating public func updateState(_ cellState: CellState) {
        self.state = cellState
    }
    
    mutating public func updateRect(_ rect: CGRect) {
        self.rect = rect
    }
    
    mutating public func updateCellColor(_ color: cellColor) {
        self.backgroundColor = color
    }
}

// Note Part
extension Cell {
    mutating func addNumForNote(_ num: Int) {
        self._noteArray[num-1] = true
    }
    
    mutating func subNumForNote(_ num: Int) {
        self._noteArray[num-1] = false
    }
    
    mutating func clearNoteArray() {
        self._noteArray = [Bool](repeating: false, count: 9)
    }
    
    func isNoteExist(_ num: Int) -> Bool {
        return _noteArray[num-1] == true
    }
}
