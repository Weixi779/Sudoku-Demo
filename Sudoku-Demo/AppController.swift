//
//  AppController.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//
import Foundation
import SwiftUI

@MainActor
final class AppController: ObservableObject {
    @Published var sudoku: SudokuController {
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
    
    private var sudokuTask: Task<(), Never>? = nil
    
    init() {
        guard let data = UserDefaults.standard.data(forKey: "sudoku") else {
            self.sudoku = SudokuController()
            return
        }
        
        let sudoku = try! JSONDecoder().decode(SudokuController.self, from: data)
        self.sudoku = sudoku
    }
    
    func createNewSudoku() {
        sudokuTask?.cancel()
        sudokuTask = Task.init {
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
//        sudoku.timerCounter.resetTime()
    }
    
    func cancelCrateSudoku() {
        sudokuTask?.cancel()
        isSolvingSudoku = false
    }
}
