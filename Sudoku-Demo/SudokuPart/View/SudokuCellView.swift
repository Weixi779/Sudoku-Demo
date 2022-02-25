//
//  SudokuCellView.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//

import Foundation
import SwiftUI

struct SudokuCellView: View {
    @EnvironmentObject var controller: AppController
    var colorSet: ColorController  { controller.color }
    var board: [[Cell]] { controller.sudoku.board }
    var cell: Cell { board[x][y] }
    var state: CellState { cell.cellState }
    
    let x: Int
    let y: Int

    var body: some View {
        VStack {
            _buildCellView
                .contentShape(Rectangle())
        }
        .border(Color.black.opacity(0.1), width: 1)
        .background(PostionSetter)
        .onTapGesture {
            controller.sudoku.selectAction(x, y)
        }
    }
    
    var PostionSetter: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .onAppear {
                    let rect = geometry.frame(in: .named("sudoku"))
                    controller.sudoku.initCellPostion(x, y, rect)
                }
        }
    }
}

extension SudokuCellView {
    private var _buildCellView: some View {
        let cellColor: Color = colorSet.getColor(ColorSet.background(cell.backgroundColor))
        
        @ViewBuilder var helper: some View {
            switch state {
            case .normal: _bulidValueView
            case .note: _buildNoteView(cell: cell)
            }
        }
        return VStack {
            helper
                .cellAdaptive()
                .background(cellColor)
        }
    }
}

extension SudokuCellView {
   private var _bulidValueView: some View {
        let fontColor: Color = colorSet.getColor(ColorSet.font(cell.fontColor))
        
        return Text(cell.fillValue == 0 ? "" : "\(cell.fillValue)")
            .foregroundColor(fontColor)
    }
}

extension SudokuCellView {
    struct _buildNoteView: View {
        var cell: Cell
        func arrIndex(_ row: Int, _ col: Int) -> Int {
            return (col+row*3) + 1
        }
        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                ForEach(0..<3) { row in
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(0..<3){ col in
                            Text( cell.isNoteExist(arrIndex(row, col)) ? " \(arrIndex(row,col))" : "" )
                                .noteAdaptive()
                        }
                    }
                }
            }
        }
        
    }
}



//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        _buildNoteView()
//    }
//}
