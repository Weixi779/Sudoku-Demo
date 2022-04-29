//
//  CellList.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/3/10.
//

import Foundation

struct CellList: Codable {
    // 读写整个棋盘情况 [[fillValue=1][fillValue=2]....[fillValue=9]]
    private var _cellList: [[Cell]]
    
    init() {
        self._cellList = [[Cell]](repeating: [Cell](), count: 9)
    }
    
    // 功能内都有对于0的保护
    // 添加cell到list中
    mutating func fillCellToList(_ cell: Cell) {
        guard cell.fillValue != 0 else { return }
        _cellList[cell.fillValue-1].append(cell)
    }
    
    /// 给一个值返回[Cell]
    func cellListArray(_ fillValue: Int) -> [Cell] {
        guard fillValue != 0 else { return [Cell]() }
        return _cellList[fillValue-1]
    }
    
    /// 给一个值返回[Cell]数量
    func cellListArrayCount(_ fillValue: Int) -> Int {
        guard fillValue != 0 else { return -1 }
        return _cellList[fillValue-1].count
    }
    /// 返回共填入多少数字
    func cellListTotalCount() -> Int {
        return _cellList.flatMap{$0}.count
    }
}
