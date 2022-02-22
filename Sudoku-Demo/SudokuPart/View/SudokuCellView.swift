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
        
        return VStack {
            _bulidValueView
                .adaptiveFrame()
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
