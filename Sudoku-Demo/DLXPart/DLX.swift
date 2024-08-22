//
//  DLX.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//
import Foundation

struct DLX {
    private let boardSize: Int
    private let boxSize: Int
    private var board: [[Int]]
    private var rowSet: [[Bool]]
    private var colSet: [[Bool]]
    private var boxSet: [[Bool]]
    
    init() {
        board = [
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
        boardSize = board.count
        boxSize = Int(sqrt(Double(boardSize)))
        rowSet = [[Bool]](repeating: [Bool](repeating: false, count: boardSize), count: boardSize)
        colSet = [[Bool]](repeating: [Bool](repeating: false, count: boardSize), count: boardSize)
        boxSet = [[Bool]](repeating: [Bool](repeating: false, count: boardSize), count: boardSize)
        initSubsets()
    }
    
    init(_ board: [[Int]]) {
        self.board = board
        boardSize = board.count
        boxSize = Int(sqrt(Double(boardSize)))
        rowSet = [[Bool]](repeating: [Bool](repeating: false, count: boardSize), count: boardSize)
        colSet = [[Bool]](repeating: [Bool](repeating: false, count: boardSize), count: boardSize)
        boxSet = [[Bool]](repeating: [Bool](repeating: false, count: boardSize), count: boardSize)
        initSubsets()
    }
    
    private func computeBoxNo(_ i: Int, _ j: Int) -> Int {
        let boxRow = i / boxSize
        let boxCol = j / boxSize
        return boxRow * boxSize + boxCol
    }
    
    // 是否有效
    private func isValid(_ i:Int, _ j: Int, _ val:Int) -> Bool {
        let tempVal = val - 1
        let isPresent = rowSet[i][tempVal] || colSet[j][tempVal] || boxSet[computeBoxNo(i, j)][tempVal]
        return !isPresent
    }
    
    // 初始化数据
    private mutating func initSubsets() {
        for i in 0..<board.count {
            for j in 0..<board[i].count {
                let value = board[i][j]
                if value != 0 {
                    setSubsetValue(i, j, value, true)
                }
            }
        }
    }
    
    // 设置数值
    private mutating func setSubsetValue(_ i: Int, _ j: Int, _ value: Int, _ present: Bool) {
        rowSet[i][value - 1] = present
        colSet[j][value - 1] = present
        boxSet[computeBoxNo(i, j)][value - 1] = present
    }
    
    // 提炼方法
    private mutating func nextStep(_ i: inout Int, _ j: inout Int) {
        if i == boardSize {
            i = 0
            j += 1
        }
    }
}

// 解数独Part
// 接口 solve()
extension DLX {
    
mutating func solve() -> [[Int]] {
        solve(0,0)
        return board
    }
    
    // 解数独
    @discardableResult
    private mutating func solve(_ i: Int, _ j: Int) -> Bool{
        var i = i , j = j
        
        nextStep(&i, &j)
        
        // 成功条件
        if j == boardSize { return true }
        
        // 如果是已知
        if board[i][j] != 0 { return solve(i+1, j) }
        
        // 从1到9遍历
        for value in (1...boardSize) {
            if isValid(i, j, value) {
                board[i][j] = value
                setSubsetValue(i, j, value, true)
                if solve(i+1, j) { return true }
                setSubsetValue(i, j, value, false)
            }
        }
        
        board[i][j] = 0
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
            if board[x][y] == 0 && isValid(x, y, value){
                board[x][y] = value
                setSubsetValue(x, y, value, true)
                temp += 1
            }
        }
        if initSolveSudoku(0,0) == false {
            print("初始化数独无解")
        }
        return board
    }
    
    @discardableResult
    private mutating func initSolveSudoku(_ i:Int, _ j:Int) -> Bool {
        var i = i ,j = j
        nextStep(&i, &j)
        
        // 成功条件
        if j == boardSize { return true }
        
        // 如果是已知
        if board[i][j] != 0 { return initSolveSudoku(i+1, j) }
        
        // 1到9随机遍历
        for value in (1...9).shuffled() {
            if isValid(i, j, value) {
                board[i][j] = value
                setSubsetValue(i, j, value, true)
                if initSolveSudoku(i+1, j) { return true }
                setSubsetValue(i, j, value, false)
            }
        }
        board[i][j] = 0
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
        for x in 0..<board.count {
            for y in 0..<board[x].count {
                if board[x][y] != 0 {
                    stack.append(IteratorHelper(x, y, board[x][y]))
                }
            }
        }
        stack = stack.shuffled()
    }
    
    // 无限制操作
    mutating func RemoveToSingele() -> [[Int]]{
        var stack = [IteratorHelper]()
        IteratorStack(&stack)
        for item in stack {
            board[item.x][item.y] = 0
            setSubsetValue(item.x, item.y, item.value, false)
            if check() == false {
                board[item.x][item.y] = item.value
                setSubsetValue(item.x, item.y, item.value, true)
            }
        }
        return board
    }
    
    // 有限制变更
    mutating func RemoveToSingele(_ target: Int) -> [[Int]] {
        var stack = [IteratorHelper]()
        IteratorStack(&stack)
        var reduceNumber = 0
        for item in stack {
            board[item.x][item.y] = 0
            setSubsetValue(item.x, item.y, item.value, false)
            if check() == true {
                reduceNumber += 1
                if reduceNumber >= target { return board }
            } else {
                board[item.x][item.y] = item.value
                setSubsetValue(item.x, item.y, item.value, true)
            }
        }
        return board
    }
    
    private mutating func check() -> Bool {
        var sucessfulCount = 0
        check(0, 0)
        
        func check(_ i:Int, _ j:Int) {
            var i = i , j = j
            nextStep(&i, &j)
            
            // 成功条件
            if j == boardSize {
                sucessfulCount += 1
                return
            }
            
            // 跳过已知
            if board[i][j] != 0 {
                check(i+1, j)
                return
            }
            
            // 失败条件 不止一个解
            if sucessfulCount > 1 { return }
            
            for value in (1...boardSize) {
                if isValid(i, j, value) {
                    board[i][j] = value
                    setSubsetValue(i, j, value, true)
                    check(i+1, j)
                    setSubsetValue(i, j, value, false)
                }
            }
            board[i][j] = 0
            return
        }
        return sucessfulCount == 1 ? true : false
    }

}
