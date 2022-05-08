//
//  AppController.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//
import Foundation
import SwiftUI

@MainActor
class AppController: ObservableObject {
    @Published var sudoku: SudokuController{
        didSet{
            let encoder = JSONEncoder()
            if let encoder = try? encoder.encode(sudoku) {
                UserDefaults.standard.set(encoder, forKey: "sudoku")
            }
        }
    }
    @Published var dlx: DLXController = DLXController()
    @Published var color: ColorController = ColorController()

        
    public var isSolvingSudoku: Bool = false
    
    private var _task = Task{}
    
    init() {
        if let sudoku = UserDefaults.standard.data(forKey: "sudoku"){
            let decoder = JSONDecoder()
            if let sudokuDecoded = try? decoder.decode(SudokuController.self, from: sudoku){
                self.sudoku = sudokuDecoded
                return
            }
        }
        self.sudoku = SudokuController.init()
    }
    
    func createNewSudoku() {
        _task = Task.init {
            isSolvingSudoku = true
            let result = await dlx.createSudoku()
            if Task.isCancelled { return }
            sudoku.initBoardWithArray(result.0, result.1)
            isSolvingSudoku = false
            sudoku.sudokuDiff = await dlx.getDiff()
            sudoku.recordStartGame()
        }
    }
    
    func restartSudoku() {
        sudoku.initBoardWithArray(sudoku.targetBoard, sudoku.fillBoard)
        sudoku.timerCounter.resetTime()
    }
    
    func canelCrateSudoku() {
        _task.cancel()
        isSolvingSudoku = false
    }
}
