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
 */
struct SudokuController {
    var board = [[Cell]]()
    
    var selectedStack: [Cell] = [Cell]()
    var selectedCell: Cell?
    var blockDivide = [[(Int,Int)]]()
    
    private var postionCount = 0
    private var xPostionArray = [(CGFloat,CGFloat)]()
    private var yPostionArray = [(CGFloat,CGFloat)]()
    
    init() {
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
    
mutating func initBoardWithArray(_ targetArray: [[Int]], _ fillArray :[[Int]]) {
        var cell = [[Cell]]()
        for x in 0..<9 {
            cell.append([Cell]())
            for y in 0..<9 {
                cell[x].append(
                    Cell(x: x, y: y, targetValue: targetArray[x][y], fillValue: fillArray[x][y])
                )
            }
        }
        self.board = cell
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
     - TODO:  5.相关数值点都变Highlight 
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
    }
    
//    func equalFillValueArray() ->  {
//
//    }
}

// - MARK: Postion Part
extension SudokuController {
    // - 新建位置信息 直到81个全部创建
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
    
    // - 移动点击位置Part
    /*
     一旦触发手势 调用这个函数
     */
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
    mutating func fillAction(_ fillNumber: Int) {
        // 值为零 && .know
        if let selectedCell = selectedCell {
            let x = selectedCell.x
            let y = selectedCell.y
            guard board[x][y].isCanFilled == true else { return }
            let targetValue = board[x][y].targetValue
            fillNumber == targetValue ? board[x][y].fontCorrect() : board[x][y].fontWrong()
            board[x][y].setFillValue(fillNumber)
        }
    }
}
