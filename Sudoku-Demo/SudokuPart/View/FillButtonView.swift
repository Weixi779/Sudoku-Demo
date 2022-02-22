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
                        .overlay(
                            Rectangle()
                                .stroke(Color.black.opacity(0.3), lineWidth: 4)
                                .cornerRadius(3)
                        )
                        .shadow(radius: 5)
                }


            }
        }
        
    }
}

//extension FillButtonPageView {
//    private struct _buildCellView: View {
//        let enterNumber: Int
//        let action: (Void)
//        var body: some View {
////            ZStack {
////                Color(.white)
////                Text("\(enterNumber)")
////                    .foregroundColor(Color.blue)
////            }
////            .fillButtonAdaptive()
////            .gesture(tapCallBack)
////            .shadow(radius: isTaping ? 0 : 2)
////            Button {
//////                controller.sudoku.fillAction(enterNumber)
////            } label: {
////                Text(enterNumber)
////            }
////            .fillButtonAdaptive()
////            .overlay(
////                RoundedRectangle(cornerRadius: 40)
////                    .stroke(Color.purple, lineWidth: 5)
////            )
//
//        }
//    }
//}


