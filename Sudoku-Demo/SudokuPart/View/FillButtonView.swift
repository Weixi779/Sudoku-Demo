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
    var sudoku: SudokuController { controller.sudoku }
    var body: some View {
        HStack {
            ForEach(1..<10) { num in
                Button {
                    if sudoku.cellListArrayCount(num) != 9 {
                        controller.sudoku.fillAction(num)
                    }
                } label: {
                    Text(showingNumber(num))
                        .fillButtonAdaptive()
                }
            }
        }
    }
    
    func showingNumber(_ num: Int) -> String {
        return sudoku.cellListArrayCount(num) != 9 ? "\(num)" : " "
    }
}

