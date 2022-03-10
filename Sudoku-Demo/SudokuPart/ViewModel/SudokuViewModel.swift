//
//  SudokuViewModel.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//

import Foundation
import SwiftUI

// 作为Sudoku的主要Controller
// Sudoku相关任务都建立相关Action
/*
 - 位置相关
 - 选择相关
 - 填入相关
 - 删除相关
 */
enum SudokuState {
    case fill
    case note
}

struct SudokuController {
    var board = [[Cell]]() // 数独面板
    
    var selectedStack: [Cell] = [Cell]()
    var selectedCell: Cell?
    var blockDivide = [[(Int,Int)]]() // 方便画图
    var state: SudokuState = .fill // 面板状态
    
    private var cellList: CellList = CellList()
    
    init() {
        for x in 0..<9 {
            board.append([Cell]())
            for y in 0..<9 {
                board[x].append( Cell(x: x, y: y) )
            }
        }
        self.cellList = CellList()
        self.blockDivide = self.initBlockDivide()
    }
    
    // 创建时立即执行 或者是在Restart的时候
    private mutating func initAction() {
        initBoard()
        cellList = CellList()
    }
    
    // 重置为零
    mutating func initBoard() {
        for x in 0..<board.count {
            for y in 0..<board[x].count {
                board[x][y].resetCell(0, 0)
            }
        }
    }
    
    func initBlockDivide() -> [[(Int,Int)]] {
        var blockDivide = [[(Int,Int)]]()
        let arr = [[0,1,2], [3,4,5], [6,7,8]]
        for count in 0..<9 {
            var temp = [(Int,Int)]()
            for i in arr[count/3] {
                for j in arr[count%3] {
                    temp.append((i,j))
                }
            }
            blockDivide.append(temp)
        }
        return blockDivide
    }
    
    // - MARK: 创建数独部分
    mutating func initBoardWithArray(_ targetArray: [[Int]], _ fillArray :[[Int]]) {
        initAction()
        for x in 0..<9 {
            for y in 0..<9 {
                let targetValue = targetArray[x][y]
                let fillValue = fillArray[x][y]
                board[x][y].resetCell(targetValue, fillValue)
                cellList.fillCellToList(board[x][y])
            }
        }
    }
    
    private func isCorrectCompleted() -> Bool{
        return cellList.cellListTotalCount() == 81
    }
    
    func isFilledCountFull(_ fillValue: Int) -> Bool {
        return cellList.cellListArrayCount(fillValue) != 9
    }
}

// -MARK: SudokuState Part
extension SudokuController {
    mutating func fillState() {
        state = .fill
    }
    mutating func noteState() {
        state = .note
    }
}

// option + command + <-  | fold

// - MARK: SelectAction Part
extension SudokuController {
    /*
     - 1.将之前的选过的设为空白
     - 2.过滤选区后放入selectedStack
     - 3.selectedStack设为高亮
     - 4.点击cell设为选中
     - 5.相关数值点都变Selected
     */
    mutating func selectAction(_ x: Int,_ y: Int) {
        setStackBlank() // - 1
        // - 2
        // - TODO: 过滤选区 抽取
        // - MARK: 看这里
        let block = x/3*3+y/3
        for index in 0..<9 {
            selectedStack.append(board[x][index])
            selectedStack.append(board[index][y])
            selectedStack.append(board[blockDivide[block][index].0][blockDivide[block][index].1])
        }
        // - 3
        selectedStack.forEach{ board[$0.x][$0.y].colorHighLight() }
        // - 4
        board[x][y].colorSelected()
        selectedCell = board[x][y]
        // - 5
        let selectedArray = cellList.cellListArray(selectedCell?.fillValue ?? 0) // 加入相同数据内容
        selectedStack += selectedArray
        selectedArray.forEach{ board[$0.x][$0.y].colorSelected() }
    }
    
    mutating func setStackBlank() {
        selectedStack.forEach{ board[$0.x][$0.y].colorBlank() }
        selectedStack = [Cell]()
    }
}

// - MARK: Postion Part
extension SudokuController {  
    // - 新建位置信息 直到81个全部创建(内容跟着视图走 应该只会刷新一次)
    mutating func initCellPostion(_ x: Int,_ y :Int, _ rect :CGRect) {
        board[x][y].setCellPostion(rect)
    }
    
    // - 移动点击位置Part(一旦触发手势 调用这个函数)
    mutating func coordinatesFromPostion(_ postion: CGPoint) {
        for x in 0..<board.count {
            for y in 0..<board[x].count {
                if let bool = board[x][y].rect?.contains(postion) , bool == true {
                    selectAction(x, y)
                }
            }
        }
    }
}

// - MARK: Fill Part
extension SudokuController {
    /*
     - 1.判断是否可以填入
     - 2.判断填入是否正确
     - 3.填入并选择该点 并将附近的noteArray清除填入值
     - 4.判断数独是否完成
     */
    mutating func fillAction(_ fillNumber: Int) {
        guard let selectedCell = selectedCell else { return }
        let x = selectedCell.x
        let y = selectedCell.y
        // - 1
        if board[x][y].isCanFilled == true {
            board[x][y].normalState()
            clearNote()
            // - 2
            let targetValue = board[x][y].targetValue
            if fillNumber == targetValue {
                board[x][y].fontCorrect()
                board[x][y].setFillValue(fillNumber)
                cellList.fillCellToList(board[x][y])
            } else {
                board[x][y].fontWrong()
                board[x][y].setFillValue(fillNumber)
            }
            // - 3
            let block = x/3*3+y/3
            for index in 0..<9 {
                board[x][index].subNumForNote(fillNumber)
                board[index][y].subNumForNote(fillNumber)
                board[blockDivide[block][index].0][blockDivide[block][index].1].subNumForNote(fillNumber)
            }
            selectAction(selectedCell.x,selectedCell.y)
            // - 4
            if isCorrectCompleted() == true {
                // TODO: Add completed Action
                print("Sudoku is completed!")
            }
        }
    }
}

// —MARK: Delete Part
extension SudokuController {
    /*
     // - 1.判断是否可以删除
     // - 2.判断是否可以填入
     // - 3.值置为0
     // - 4.选择为0
     */
    mutating func deleteAction() {
        guard let selectedCell = selectedCell else { return }
        let x = selectedCell.x, y = selectedCell.y
        if board[x][y].isCanFilled == true {
            board[x][y].normalState()
            board[x][y].setFillValue(0)
            clearNote()
            selectAction(x,y)
        }
    }
}

// -MARK: Note Part
extension SudokuController {
    /*
     - 1.确认可选
     - 2.确认是否存在 不存在就加上 存在就减去
     */
    mutating func noteAction(_ num: Int) {
        guard let selectedCell = selectedCell else { return }
        let x = selectedCell.x, y = selectedCell.y
        if board[x][y].isCanFilled == true {
            board[x][y].noteState()
            board[x][y].isNoteExist(num) ? board[x][y].subNumForNote(num) : board[x][y].addNumForNote(num)
        }
    }
    
    // 清空noteArray
    mutating func clearNote() {
        guard let selectedCell = selectedCell else { return }
        let x = selectedCell.x, y = selectedCell.y
        board[x][y].clearNoteArray()
    }
}
