//
//  DLXController.swift

//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//

import Foundation
import SwiftUI

actor DLXController {
    private var _diff: Difficulty = .easy
    private var _taskProgress: String = ""
    
    private var _startBoard = [[Int]]()
    private var _finalBoard = [[Int]]()
    
    private var _dotCount = 1
    
    public var isCreatingStartPlate = false;
    
    public var targetBoard: ([[Int]],[[Int]]) {
        get { return (_startBoard, _finalBoard) }
    }
    
    // 解数独
    func solve(_ board: [[Int]]) -> [[Int]] {
        var dlx = DLX(board: board)
        let res = dlx.solve()
        return res
    }
    
    // 生成接口
    func createSudoku() -> ([[Int]],[[Int]]) {
        _taskProgress = "开始生成数独..."
        
        finalPlate()
        _taskProgress = "终盘生成完毕..."
        
        startPlate()
        
        return targetBoard
    }
    
    // 生成终盘
    private func finalPlate() {
        var dlx = DLX()
        let res = dlx.initFinalPlate()
        _startBoard = res
    }
    
    // 生成初盘 -> 同时也是开始接口
    private func startPlate() {
        var dlx = DLX(board: _startBoard)
        if (_diff == .easy || _diff == .normal || _diff == .hard) {
            _finalBoard = dlx.removeToSingle(_diff.unkownCount())
        } else {
            _finalBoard = dlx.removeToSingle()
        }
    }
    
    public func updateText() {
        _dotCount += 1
        _dotCount %= 4
        var tempStr = ""
        for _ in 0..<_dotCount {
            tempStr += "."
        }
        
        _taskProgress = "正在生成初盘" + tempStr
    }
    
    public func TaskProgress() -> String {
        return _taskProgress
    }
    
    public func setDiff(_ diff: Difficulty ) {
        _diff = diff
    }
    
    public func getDiff() -> Difficulty {
        return _diff
    }
    
    public func getDiffDescription() -> String {
        return _diff.diffDescription()
    }
}
