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
    var body: some View {
        HStack {
            ForEach(1..<10) { num in
                Button {
                    controller.sudoku.fillAction(num)
                } label: {
                    Text("\(num)")
                        .fillButtonAdaptive()
                }
            }
        }
        
    }
}

