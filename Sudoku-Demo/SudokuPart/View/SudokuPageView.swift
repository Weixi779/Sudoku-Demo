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
    @Binding var tabSelection: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(controller.sudoku.diffDescription)
                    Spacer()
//                    Counter
                    Restart
                }.padding(.horizontal)
                
                SudokuView()
                FuntcionViewButton()
                FillButtonPageView()
            }.onReceive(timer) { _ in
                if tabSelection == 2 {
//                    controller.sudoku.timerCounter.addOneSeconds()
                }
            }
            if controller.isSolvingSudoku == true {
                StopCreateSudokuView
                    .onAppear {
//                        controller.sudoku.timerCounter.stopCounting()
                    }
            }
            if controller.sudoku.isCompleted == true {
                CompletedSudokuView
            }
        }
    }
    
    var Restart: some View {
        return Button {
            controller.restartSudoku()
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(.black)
        }

    }
//    var Counter: some View {
//        var timerCounter : GameTimerStore {
//            controller.sudoku.timerCounter
//        }
//        return HStack {
//            Text(timerCounter.time)
//            Button {
//                controller.sudoku.timerCounter.iconFunction()
//            } label: {
//                Image(systemName: timerCounter.iconSystemName())
//                    .foregroundColor(.black)
//            }
//        }.padding([.horizontal])
//    }
    
    var StopCreateSudokuView: some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 200, height: 60)
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            Text("正在生成数独")

            ZStack{
                Circle()
                    .frame(width: 20, height: 20, alignment: .topTrailing)
                    .foregroundColor(.gray)
                Image(systemName: "multiply")
                    .foregroundColor(.white)
            }
            .offset(x: 100, y: -30)
            .onTapGesture {
                controller.cancelCrateSudoku()
            }
        }
    }
    
    var CompletedSudokuView: some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 80)
                .foregroundColor(.white)
                .shadow(radius: 5)
            VStack(spacing: 5) {
                Text("恭喜完成数独 数据已记录")
//                Text("总用时\(controller.sudoku.timerCounter.time)")
            }
            .padding()

            ZStack{
                Circle()
                    .frame(width: 20, height: 20, alignment: .topTrailing)
                    .foregroundColor(.gray)
                Image(systemName: "multiply")
                    .foregroundColor(.white)
            }
            .offset(x: 125, y: -40)
            .onTapGesture {
                tabSelection = 1
                controller.sudoku.ClearSudokuInfo()
            }
        }
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
    var block: [[IntTumple]] {
        controller.sudoku.blockDivide
    }
    let number: Int
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<3) { x in
                HStack(spacing: 0) {
                    ForEach(0..<3) { y in
                        SudokuCellView(
                            x: block[number][x*3+y].zero ,
                            y: block[number][x*3+y].one
                        )
                    }
                }
            }
        }
        .border(Color.black.opacity(0.3), width: 1)
    }
}
