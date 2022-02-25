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
    var board = [[Cell]]()
    
    var selectedStack: [Cell] = [Cell]()
    var selectedCell: Cell?
    var blockDivide = [[(Int,Int)]]()
    private var numberCellList: [[Cell]]
    
    private var postionCount = 0
    private var xPostionArray = [(CGFloat,CGFloat)]()
    private var yPostionArray = [(CGFloat,CGFloat)]()
    
    var state: SudokuState = .fill
    
    init() {
        self.numberCellList = [[Cell]](repeating: [Cell](), count: 9)
        self.board = self.initBoard()
        self.blockDivide = self.initBlockDivide()
    }
    
    func initBoard() -> [[Cell]] {
        var cell = [[Cell]]()
        for x in 0..<9 {
            cell.append([Cell]())
            for y in 0..<9 {
                cell[x].append(
                    Cell(x: x, y: y, targetValue: 0, fillValue:0)
                )
            }
        }
        return cell
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
        var cells = [[Cell]]()
        for x in 0..<9 {
            cells.append([Cell]())
            for y in 0..<9 {
                let cell = Cell(x: x, y: y, targetValue: targetArray[x][y], fillValue: fillArray[x][y])
                cells[x].append(cell)
                fillNumberToList(cell)
            }
        }
        self.board = cells
    }
    
    private func isCorrectCompleted() -> Bool{
        return numberCellList.flatMap{$0}.count == 81
    }
}

// -MARK: 拓展NumberCellList功能
extension SudokuController {
    // 功能内都有对于0的保护
    // 添加cell到list中
    mutating func fillNumberToList(_ cell: Cell) {
        guard cell.fillValue != 0 else { return }
        numberCellList[cell.fillValue-1].append(cell)
    }
    
    // 给一个值返回[Cell]
    func cellListArray(_ fillValue: Int) -> [Cell] {
        guard fillValue != 0 else { return [Cell]() }
        return numberCellList[fillValue-1]
    }
    
    // 给一个值返回[Cell]数量
    func cellListArrayCount(_ fillValue: Int) -> Int {
        guard fillValue != 0 else { return -1 }
        return numberCellList[fillValue-1].count
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
        // - 1
        selectedStack.forEach{ board[$0.x][$0.y].colorBlank() }
        selectedStack = [Cell]()
        // - 2
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
        let selectedArray = cellListArray(selectedCell?.fillValue ?? 0)
        selectedStack += selectedArray
        selectedArray.forEach{ board[$0.x][$0.y].colorSelected() }
    }
}

// - MARK: Postion Part
extension SudokuController {  
    // - 新建位置信息 直到81个全部创建(内容跟着视图走 应该只会刷新一次)
    mutating func initCellPostion(_ x: Int,_ y :Int, _ rect :CGRect) {
        let startX = rect.minX
        let startY = rect.minY
        let endX = startX + rect.size.width
        let endY = startY + rect.size.height
        let postion = Postion(startX: startX, startY: startY, endX: endX, endY: endY)
        board[x][y].setCellPostion(postion)
        postionCount += 1
        if postionCount == 81 {
            updatePostionArray()
        }
    }
    
    // - 更新cell中的位置信息 按大小更新
    mutating func updatePostionArray() {
        for cell in board[0] {
            xPostionArray.append((cell.postion!.startX, cell.postion!.endX))
        }
        
        for index in 0..<board.count {
            let cell = board[index][0]
            yPostionArray.append((cell.postion!.startY, cell.postion!.endY))
        }
    }
    
    // - 移动点击位置Part(一旦触发手势 调用这个函数)
    mutating func coordinatesFromPostion(_ xPostion: CGFloat, _ yPostion: CGFloat) {
        var resX = -1
        var resY = -1
        for indexX in 0..<xPostionArray.count {
            if (xPostion > xPostionArray[indexX].0 && xPostion < xPostionArray[indexX].1) {
                resX = indexX
                break
            }
        }
        for indexY in 0..<yPostionArray.count {
            if (yPostion > yPostionArray[indexY].0 && yPostion < yPostionArray[indexY].1) {
                resY = indexY
                break
            }
        }
        if resX != -1 && resY != -1 {
            selectAction(resX, resY)
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
                board[x][y].isCanFilled = false
                fillNumberToList(board[x][y])
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
