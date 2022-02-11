//
//  SudokuViewModel.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//

import Foundation
import SwiftUI

struct SudokuController {
    var board = [[Cell]]()
    
    var selectedStack: [Cell] = [Cell]()
    var selectedCell: Cell?
    var blockDivide = [[(Int,Int)]]()
    
    private var postionCount = 0
    private var xPostionArray = [(CGFloat,CGFloat)]()
    private var yPostionArray = [(CGFloat,CGFloat)]()
    
    init() {
        // TODO: It will be delete after git testing
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

// - MARK: SelectAction Part
extension SudokuController {
    mutating func selectAction(_ x: Int,_ y: Int) {
        selectedStack.forEach{ board[$0.x][$0.y].colorBlank() }
        
        selectedStack = [Cell]()
        let block = x/3*3+y/3
        for index in 0..<9 {
            selectedStack.append(board[x][index])
            selectedStack.append(board[index][y])
            selectedStack.append(board[blockDivide[block][index].0][blockDivide[block][index].1])
        }
        selectedStack.forEach{ board[$0.x][$0.y].colorHighLight() }
        board[x][y].colorSelected()
        selectedCell = board[x][y]
    }
    
//    mutating func allBlank() {
//        for x in 0..<9 {
//            for y in 0..<9 {
//                board[x][y].colorBlank()
//            }
//        }
//    }
}

// - MARK: Postion Part
extension SudokuController {
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
    
    mutating func updatePostionArray() {
        for cell in board[0] {
            xPostionArray.append((cell.postion!.startX, cell.postion!.endX))
        }
        
        for index in 0..<board.count {
            let cell = board[index][0]
            yPostionArray.append((cell.postion!.startY, cell.postion!.endY))
        }
    }
    
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


