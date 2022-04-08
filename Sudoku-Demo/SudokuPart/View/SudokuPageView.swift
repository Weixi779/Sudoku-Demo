//
//  SudokuPageView.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//

import Foundation
import SwiftUI

struct SudokuPageView: View {
    @EnvironmentObject var controller: AppController
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Button("create sudoku") {
                controller.createNewSudoku()
            }
            HStack {
                Counter
            }
            
            SudokuView()
            FuntcionViewButton()
            FillButtonPageView()
        }.onReceive(timer) { _ in
            controller.sudoku.timerCounter.addOneSeconds()
        }
    }
    
    var Counter: some View {
        var timerCounter : TimerCounter {
            controller.sudoku.timerCounter
//            arrow.triangle.2.circlepath
        }
        return HStack {
            Text(timerCounter.time)
            Button {
                controller.sudoku.timerCounter.iconFunction()
            } label: {
                Image(systemName: timerCounter.iconSystemName())
                    .foregroundColor(.black)
            }
        }.padding([.horizontal])
    }
}

struct SudokuView: View {
    @GestureState var isLongPressde = false
    @EnvironmentObject var controller: AppController
    
    var drag: some Gesture {
        DragGesture()
            .updating($isLongPressde) { value, _, _ in
                controller.sudoku.coordinatesFromPostion(value.location)
            }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<3) { x in
                HStack (spacing: 0) {
                    ForEach(0..<3) { y in
                        SudokuBlockView(number: x*3+y)
                    }
                }
            }
        }
        .border(Color.black, width: 1.5)
        .padding()
        .gesture(drag)
        .coordinateSpace(name: "sudoku")
    }
}

struct SudokuBlockView: View {
    @EnvironmentObject var controller: AppController
    var block: [[(Int,Int)]] {
        controller.sudoku.blockDivide
    }
    let number: Int
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<3) { x in
                HStack(spacing: 0) {
                    ForEach(0..<3) { y in
                        SudokuCellView(
                            x: block[number][x*3+y].0 ,
                            y: block[number][x*3+y].1
                        )
                    }
                }
            }
        }
        .border(Color.black.opacity(0.3), width: 1)
    }
}
