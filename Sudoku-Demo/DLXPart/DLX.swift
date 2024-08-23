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
        self.init(board: [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9))
    }

    init(board: [[Int]]) {
        self.board = board
        self.boardSize = board.count
        self.boxSize = Int(sqrt(Double(boardSize)))
        self.rowSet = DLX.newBoolArray(boardSize)
        self.colSet = DLX.newBoolArray(boardSize)
        self.boxSet = DLX.newBoolArray(boardSize)
        self.initializeSets()
    }

    private static func newBoolArray(_ size: Int) -> [[Bool]] {
        return [[Bool]](repeating: [Bool](repeating: false, count: size), count: size)
    }

    private func computeBoxIndex(_ row: Int, _ col: Int) -> Int {
        let boxRow = row / boxSize
        let boxCol = col / boxSize
        return boxRow * boxSize + boxCol
    }

    private func isValidMove(_ row: Int, _ col: Int, _ value: Int) -> Bool {
        let adjustedValue = value - 1
        return !rowSet[row][adjustedValue] && !colSet[col][adjustedValue] && !boxSet[computeBoxIndex(row, col)][adjustedValue]
    }

    private mutating func initializeSets() {
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                let value = board[row][col]
                if value != 0 {
                    updateSetValue(row, col, value, true)
                }
            }
        }
    }

    private mutating func updateSetValue(_ row: Int, _ col: Int, _ value: Int, _ present: Bool) {
        let adjustedValue = value - 1
        rowSet[row][adjustedValue] = present
        colSet[col][adjustedValue] = present
        boxSet[computeBoxIndex(row, col)][adjustedValue] = present
    }

    private mutating func advanceToNextStep(row: inout Int, col: inout Int) {
        if row == boardSize {
            row = 0
            col += 1
        }
    }
}

// Sudoku Solving Part
extension DLX {
    mutating func solve() -> [[Int]] {
        solve(0, 0)
        return board
    }
    
    @discardableResult
    private mutating func solve(_ row: Int, _ col: Int) -> Bool {
        var row = row, col = col
        advanceToNextStep(row: &row, col: &col)
        
        if col == boardSize { return true }
        
        if board[row][col] != 0 { return solve(row + 1, col) }
        
        for value in 1...boardSize {
            if isValidMove(row, col, value) {
                board[row][col] = value
                updateSetValue(row, col, value, true)
                if solve(row + 1, col) { return true }
                updateSetValue(row, col, value, false)
            }
        }
        
        board[row][col] = 0
        return false
    }
}

// Final Sudoku Generation Part
extension DLX {
    mutating func initFinalPlate() -> [[Int]] {
        let initialCount = 13
        var placedNumbers = 0
        
        while placedNumbers < initialCount {
            let x = Int.random(in: 0..<boardSize)
            let y = Int.random(in: 0..<boardSize)
            let value = Int.random(in: 1...boardSize)
            
            if board[x][y] == 0 && isValidMove(x, y, value) {
                board[x][y] = value
                updateSetValue(x, y, value, true)
                placedNumbers += 1
            }
        }
        
        if !initSolveSudoku(0, 0) {
            print("Initialization of Sudoku failed, unsolvable board.")
        }
        
        return board
    }
    
    @discardableResult
    private mutating func initSolveSudoku(_ row: Int, _ col: Int) -> Bool {
        var row = row, col = col
        advanceToNextStep(row: &row, col: &col)
        
        if col == boardSize { return true }
        
        if board[row][col] != 0 { return initSolveSudoku(row + 1, col) }
        
        for value in (1...boardSize).shuffled() {
            if isValidMove(row, col, value) {
                board[row][col] = value
                updateSetValue(row, col, value, true)
                if initSolveSudoku(row + 1, col) { return true }
                updateSetValue(row, col, value, false)
            }
        }
        
        board[row][col] = 0
        return false
    }
}

// Iterator Helper for Sudoku
fileprivate struct IteratorHelper {
    let x: Int
    let y: Int
    let value: Int
    
    init(_ x: Int, _ y: Int, _ value: Int) {
        self.x = x
        self.y = y
        self.value = value
    }
}

// Initial Board Setup Part
extension DLX {
    private func iteratorStack(_ stack: inout [IteratorHelper]) {
        for x in 0..<board.count {
            for y in 0..<board[x].count {
                if board[x][y] != 0 {
                    stack.append(IteratorHelper(x, y, board[x][y]))
                }
            }
        }
        stack.shuffle()
    }
    
    mutating func removeToSingle() -> [[Int]] {
        var stack = [IteratorHelper]()
        iteratorStack(&stack)
        
        for item in stack {
            board[item.x][item.y] = 0
            updateSetValue(item.x, item.y, item.value, false)
            if !check() {
                board[item.x][item.y] = item.value
                updateSetValue(item.x, item.y, item.value, true)
            }
        }
        
        return board
    }
    
    mutating func removeToSingle(_ target: Int) -> [[Int]] {
        var stack = [IteratorHelper]()
        iteratorStack(&stack)
        var removedCount = 0
        
        for item in stack {
            board[item.x][item.y] = 0
            updateSetValue(item.x, item.y, item.value, false)
            if check() {
                removedCount += 1
                if removedCount >= target { return board }
            } else {
                board[item.x][item.y] = item.value
                updateSetValue(item.x, item.y, item.value, true)
            }
        }
        
        return board
    }
    
    private mutating func check() -> Bool {
        var solutionCount = 0
        
        func check(_ row: Int, _ col: Int) {
            var row = row, col = col
            advanceToNextStep(row: &row, col: &col)
            
            if col == boardSize {
                solutionCount += 1
                return
            }
            
            if board[row][col] != 0 {
                check(row + 1, col)
                return
            }
            
            if solutionCount > 1 { return }
            
            for value in 1...boardSize {
                if isValidMove(row, col, value) {
                    board[row][col] = value
                    updateSetValue(row, col, value, true)
                    check(row + 1, col)
                    updateSetValue(row, col, value, false)
                }
            }
            
            board[row][col] = 0
        }
        
        check(0, 0)
        return solutionCount == 1
    }
}
