//
//  DLXController.swift

//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//

import Foundation

// TODO: List
// 最重要的首先就是 要将结果放在主线程去刷新 √
// 1. 添加中途取消机制 (长时间没完成自动取消)
// 2. 难度系数选择

// 终盘 -> 解数独 -> 初盘
enum solveState {
    case finaly, solving, start
}

enum difficulty {
    case easy, normal, hard, unlimit, hell
}

extension difficulty {
//    func diffDescription() -> String {
//        switch (self) {
//        case.easy: return "简单"
//        case.normal: return "普通"
//        case.hard: return "困难"
//        case.unlimit: return "无限制"
//        case.hell: return "地狱"
//        }
//    }
    
    func unkownCount() -> Int {
        switch (self) {
        case.easy: return Int.random(in: 10..<16)
        case.normal: return Int.random(in: 25..<33)
        case.hard: return Int.random(in: 40..<50)
        case.unlimit: return -1
        case.hell: return -1
        }
    }
}

actor DLXController {
    // - TODO: 移到AppController里头进行Task操作
    var isSolvingSudoku: Bool = false
    private var _state: solveState = .start
    private var _diff: difficulty = .easy
//    public var diff: String {
//        _diff.diffDescription()
//    }
    
    private var _startBoard = [[Int]]()
    private var _finalBoard = [[Int]]()
    
    public var targetBoard: ([[Int]],[[Int]]) {
        get { return (_startBoard, _finalBoard) }
    }
    
    // 解数独
    func solve(_ board: [[Int]]) -> [[Int]] {
        _state = .solving
        //startSolveSudoku()
        var dlx = DLX(board)
        let res = dlx.solve()
        //finishSolveSudoku()
        return res
    }
    
    // 生成终盘
    func finalPlate() -> [[Int]] {
        _state = .finaly
        //startSolveSudoku()
        var dlx = DLX()
        let res = dlx.initFinalPlate()
        //finishSolveSudoku()
        return res
    }
    
    // 生成初盘 -> 同时也是开始接口
    func createStartPlate() -> ([[Int]],[[Int]]) {
        _startBoard = finalPlate()
        var dlx = DLX(_startBoard)
        //state = .start
        //startSolveSudoku()
        if (_diff == .easy || _diff == .normal || _diff == .hard) {
            _finalBoard = dlx.RemoveToSingele(_diff.unkownCount())
        } else if (_diff == .unlimit || _diff == .hell) {
            _finalBoard = dlx.RemoveToSingele()
        }
        //finishSolveSudoku()
        return targetBoard
    }
    
    // 解释函数
    private func startSolveSudoku() {
        isSolvingSudoku = true
        switch _state {
        case .start: print("-----------------正在生成初始数独,请稍后-----------------")
        case .solving: print("--------------------正在解数独,请稍后-------------------")
        case .finaly: print("-----------------正在生成最终数独,请稍后-----------------")
        }
    }
    
    // 解释函数
    private func finishSolveSudoku() {
        isSolvingSudoku = false
        switch _state {
        case .start: print("-----------------初始数独生成完毕-----------------")
        case .solving: print("-------------------数独解决完毕------------------")
        case .finaly: print("-----------------最终数独解决完毕-----------------")
        }
    }
    
    public func setDiff(_ diff: difficulty ) {
        _diff = diff
    }
}
