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

actor DLXController {
    var isSolvingSudoku: Bool = false
    private var state: solveState = .start
    
    // 解数独
    func solve(_ board: [[Int]]) -> [[Int]] {
        state = .solving
        startSolveSudoku()
        var dlx = DLX(board)
        let res = dlx.solve()
        finishSolveSudoku()
        return res
    }
    
    // 生成终盘
    func finalPlate() -> [[Int]] {
        state = .finaly
        startSolveSudoku()
        var dlx = DLX()
        let res = dlx.initFinalPlate()
        finishSolveSudoku()
        return res
    }
    
    // 生成初盘 -> 同时也是开始接口
    func createStartPlate() -> ([[Int]],[[Int]]) {
        let startBoard = finalPlate()
        var dlx = DLX(startBoard)
        state = .start
        startSolveSudoku()
        let finalBoard = dlx.RemoveToSingele()
        finishSolveSudoku()
        return (startBoard, finalBoard)
    }
    
    // 解释函数
    private func startSolveSudoku() {
        isSolvingSudoku = true
        switch state {
        case .start: print("-----------------正在生成初始数独,请稍后-----------------")
        case .solving: print("--------------------正在解数独,请稍后-------------------")
        case .finaly: print("-----------------正在生成最终数独,请稍后-----------------")
        }
    }
    
    // 解释函数
    private func finishSolveSudoku() {
        isSolvingSudoku = false
        switch state {
        case .start: print("-----------------初始数独生成完毕-----------------")
        case .solving: print("-------------------数独解决完毕------------------")
        case .finaly: print("-----------------最终数独解决完毕-----------------")
        }
    }
}



