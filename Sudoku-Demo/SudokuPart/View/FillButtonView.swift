//
//  FillButtonView.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/15.
//

import Foundation
import SwiftUI

struct FillButtonPageView: View {
    @EnvironmentObject var controller: AppController
    var state: SudokuState { controller.sudoku.state }
    var sudoku: SudokuController { controller.sudoku }
    
    func canUsed(_ num: Int) -> Bool {
        return sudoku.isFilledCountFull(num)
    }
    var body: some View {
        HStack {
            ForEach(1..<10) { num in
                Button {
                    if canUsed(num) {
                        switch state {
                        case .fill: controller.sudoku.fillAction(num)
                        case .note: controller.sudoku.noteAction(num)
                        }
                    }
                } label: {
                    Text(canUsed(num) ? "\(num)" : " ")
                        .fillButtonAdaptive()
                }
            }
        }
    }
}

