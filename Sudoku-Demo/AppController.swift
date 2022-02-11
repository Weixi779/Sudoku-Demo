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
    
    func createNewSudoku()  {
        Task.init {
            let result = await dlx.createStartPlate()
            sudoku.initBoardWithArray(result.0, result.1)
        }
    }
    
    
}
