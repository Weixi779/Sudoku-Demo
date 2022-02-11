//
//  DLX.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//
import Foundation

struct DLX {
    private let mBoardSize: Int
    private let mBoxSize: Int
    private var mBoard: [[Int]]
    private var mRowSubset: [[Bool]]
    private var mColSubset: [[Bool]]
    private var mBoxSubset: [[Bool]]
    
    init() {
        mBoard = [
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0]
            ]
        mBoardSize = mBoard.count
        mBoxSize = Int(sqrt(Double(mBoardSize)))
        mRowSubset = [[Bool]](repeating: [Bool](repeating: false, count: mBoardSize), count: mBoardSize)
        mColSubset = [[Bool]](repeating: [Bool](repeating: false, count: mBoardSize), count: mBoardSize)
        mBoxSubset = [[Bool]](repeating: [Bool](repeating: false, count: mBoardSize), count: mBoardSize)
        initSubsets()
    }
    
    init(_ board: [[Int]]) {
        mBoard = board
        mBoardSize = board.count
        mBoxSize = Int(sqrt(Double(mBoardSize)))
        mRowSubset = [[Bool]](repeating: [Bool](repeating: false, count: mBoardSize), count: mBoardSize)
        mColSubset = [[Bool]](repeating: [Bool](repeating: false, count: mBoardSize), count: mBoardSize)
        mBoxSubset = [[Bool]](repeating: [Bool](repeating: false, count: mBoardSize), count: mBoardSize)
        initSubsets()
    }
    
    private func computeBoxNo(_ i: Int, _ j: Int) -> Int {
        let boxRow = i / mBoxSize
        let boxCol = j / mBoxSize
        return boxRow * mBoxSize + boxCol
    }
    
    private func isValid(_ i:Int, _ j: Int, _ val:Int) -> Bool {
        let tempVal = val - 1
        let isPresent = mRowSubset[i][tempVal] || mColSubset[j][tempVal] || mBoxSubset[computeBoxNo(i, j)][tempVal]
        return !isPresent
    }
    
    private mutating func initSubsets() {
        for i in 0..<mBoard.count {
            for j in 0..<mBoard[i].count {
                let value = mBoard[i][j]
                if value != 0 { setSubsetValue(i, j, value, true) }
            }
        }
    }
    
    private mutating func setSubsetValue(_ i: Int, _ j: Int, _ value: Int, _ present: Bool) {
        mRowSubset[i][value - 1] = present
        mColSubset[j][value - 1] = present
        mBoxSubset[computeBoxNo(i, j)][value - 1] = present
    }
}

// 解数独Part
// 接口 solve()
extension DLX {
    
mutating func solve() -> [[Int]] {
        solve(0,0)
        return mBoard
    }
    
    @discardableResult
    private mutating func solve(_ i: Int, _ j: Int) -> Bool{
        var i = i , j = j
        if i == mBoardSize {
            i = 0
            j += 1
            if j == mBoardSize { return true }
        }
        
        if mBoard[i][j] != 0 {
            return solve(i+1, j)
        }
        
        for value in (1...mBoardSize) {
            if isValid(i, j, value) {
                mBoard[i][j] = value
                setSubsetValue(i, j, value, true)
                if solve(i+1, j) { return true }
                setSubsetValue(i, j, value, false)
            }
        }
        
        mBoard[i][j] = 0
        return false
    }
}

// 生成终盘Part
/*
 - 接口: initFinalSudoku
 */
extension DLX {
    mutating func initFinalPlate() -> [[Int]] {
        let count = 13
        var temp = 0
        while temp != count {
            let x = Int.random(in: 0..<9)
            let y = Int.random(in: 0..<9)

            let value = Int.random(in: 1...9)
            if mBoard[x][y] == 0 && isValid(x, y, value){
                mBoard[x][y] = value
                setSubsetValue(x, y, value, true)
                temp += 1
            }
        }
        initSolveSudoku(0,0)
        return mBoard
    }
    
    @discardableResult
    private mutating func initSolveSudoku(_ i:Int, _ j:Int) -> Bool {
        var i = i ,j = j
        if i == mBoardSize {
            i = 0
            j += 1
            if j == mBoardSize { return true }
        }
        if mBoard[i][j] != 0 { return initSolveSudoku(i+1, j) }
        
        for value in (1...9).shuffled() {
            if isValid(i, j, value) {
                mBoard[i][j] = value
                setSubsetValue(i, j, value, true)
                if initSolveSudoku(i+1, j) { return true }
                setSubsetValue(i, j, value, false)
            }
        }
        mBoard[i][j] = 0
        return false
    }
}

fileprivate struct IteratorHelper {
    let x: Int
    let y: Int
    let value: Int
    
    init(_ x: Int,_ y: Int ,_ value: Int) {
        self.x = x
        self.y = y
        self.value = value
    }
}
//-MARK: 初盘Part
extension DLX {
    private func IteratorStack(_ stack: inout [IteratorHelper]) {
        for x in 0..<mBoard.count {
            for y in 0..<mBoard[x].count {
                if mBoard[x][y] != 0 {
                    stack.append(IteratorHelper(x, y, mBoard[x][y]))
                }
            }
        }
        stack = stack.shuffled()
    }
    
    mutating func RemoveToSingele() -> [[Int]]{
        var stack = [IteratorHelper]()
        IteratorStack(&stack)
        var reduceNumber = 0
        for item in stack {
            mBoard[item.x][item.y] = 0
            setSubsetValue(item.x, item.y, item.value, false)
            if check() == true {
                reduceNumber += 1
                // TODO: 跳出操作
            } else {
                mBoard[item.x][item.y] = item.value
                setSubsetValue(item.x, item.y, item.value, true)
            }
        }
        return mBoard
    }
    
    private mutating func check() -> Bool {
        var sucessfulCount = 0
        check(0, 0)
        
        func check(_ i:Int, _ j:Int) {
            var i = i , j = j
            if i == mBoardSize {
                i = 0
                j += 1
                //成功条件
                if j == mBoardSize {
                    sucessfulCount += 1
                    return
                }
            }
            if mBoard[i][j] != 0 {
                check(i+1, j)
                return
            }
            if sucessfulCount > 1 { return }
            for value in (1...mBoardSize) {
                if isValid(i, j, value) {
                    mBoard[i][j] = value
                    setSubsetValue(i, j, value, true)
                    check(i+1, j)
                    setSubsetValue(i, j, value, false)
                }
            }
            mBoard[i][j] = 0
            return
        }
        return sucessfulCount == 1 ? true : false
    }
    

}
