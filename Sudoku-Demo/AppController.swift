//
//  AppController.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//
import Foundation

@MainActor
class AppController: ObservableObject {
    @Published var sudoku: SudokuController{
        didSet{
            let encoder = JSONEncoder()
            if let encoder = try? encoder.encode(sudoku) {
                UserDefaults.standard.set(encoder, forKey: "sudoku")  //一旦改变 使用编码器
            }
        }
    }
    @Published var dlx: DLXController = DLXController()
    @Published var color: ColorController = ColorController()
        
    public var isSolvingSudoku: Bool = false
    
    private var _task = Task{}
    
    init() {
        if let courier = UserDefaults.standard.data(forKey: "sudoku"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(SudokuController.self, from: courier){
                self.sudoku = decoded
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
            sudoku.diffDescription = await dlx.getDiffDescription()
            isSolvingSudoku = false
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
