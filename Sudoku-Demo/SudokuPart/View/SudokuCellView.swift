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
    let x: Int
    let y: Int
    var colorSet: ColorController  { controller.color }
    var board: [[Cell]] { controller.sudoku.board }
    var cell: Cell { board[x][y] }
    
    var body: some View {
        VStack {
            cellView
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
    var cellView: some View {
        let cellColor: Color = colorSet.getColor(ColorSet.background(cell.backgroundColor))
        
        return VStack {
            valueView
                .adaptiveFrame()
                .background(cellColor)
        }
    }
}

extension SudokuCellView {
    var valueView: some View {
        let fontColor: Color = colorSet.getColor(ColorSet.font(cell.fontColor))
        
        return Text(cell.fillValue == 0 ? "" : "\(cell.fillValue)")
            .foregroundColor(fontColor)
    }
}


extension View {
    func adaptiveFrame() -> some View {
        self.modifier(AdaptiveFrame())
    }
}

// 自适应尺寸大小
fileprivate struct AdaptiveFrame: ViewModifier {
    let screenWidth = UIScreen.main.bounds.width
    func body(content: Content) -> some View {
        content
            .font(.system(size: screenWidth/11, weight: .light, design: .default))
            .frame(width: screenWidth/10, height: screenWidth/10)
    }
}

