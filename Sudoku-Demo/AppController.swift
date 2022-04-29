//
//  AppController.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//
import Foundation

@MainActor
class AppController: ObservableObject {
    @Published var sudoku: SudokuController = SudokuController()
    @Published var dlx: DLXController = DLXController()
    @Published var color: ColorController = ColorController()
        
    public var isSolvingSudoku: Bool = false
    
    private var _task = Task{}
    
    func createNewSudoku() {
        _task = Task.init {
            isSolvingSudoku = true
            let result = await dlx.createSudoku()
            if Task.isCancelled { return }
            sudoku.initBoardWithArray(result.0, result.1)
            isSolvingSudoku = false
        }
    }
    
    
    func restartSudoku() {
        Task {
            let result = await dlx.targetBoard
            sudoku.initBoardWithArray(result.0, result.1)
            sudoku.timerCounter.resetTime()
        }
    }
    
    func canelCrateSudoku() {
        _task.cancel()
        isSolvingSudoku = false
    }
}
