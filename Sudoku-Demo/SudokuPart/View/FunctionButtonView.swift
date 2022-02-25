//
//  FunctionButtonView.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/24.
//

import Foundation
import SwiftUI

struct FuntcionViewButton: View {
    @EnvironmentObject var controller: AppController
    var state: SudokuState { controller.sudoku.state }
    var body: some View {
        HStack {
            _fillStateButton
            _noteStateButton
            Spacer()
            _deleteButton
        }
        .padding([.horizontal])
    }
    
    var _fillStateButton: some View {
        _bulidButtonView(systemName: "pencil", textString: "填入")
            .padding([.horizontal])
            .foregroundColor(stateColor(.fill))
            .onTapGesture {
                controller.sudoku.fillState()
            }
    }
    
    var _noteStateButton: some View {
        _bulidButtonView(systemName: "pencil.and.outline", textString: "笔记")
            .padding([.horizontal])
            .foregroundColor(stateColor(.note))
            .onTapGesture {
                controller.sudoku.noteState()
            }
    }
    
    var _deleteButton: some View {
        Button {
            controller.sudoku.deleteAction()
        } label: {
            _bulidButtonView(systemName: "pencil.slash", textString: "删除")
        }
        .padding([.horizontal])
        .foregroundColor(Color.black)
    }
    
    struct _bulidButtonView: View {
        let systemName: String
        let textString: String
        
        var body: some View {
            VStack (spacing: 0) {
                Image(systemName: systemName)
                    .resizable()
                    .functionButtonAdaptive()
                Text(textString)
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
        }
    }
    
    private func stateColor(_ buttonState: SudokuState) -> Color {
        return state == buttonState ? Color.blue : Color.gray
    }
}
