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
    
    var body: some View {
        HStack {
            Spacer()
            _deleteButtonView
        }
    }
    
    var _deleteButtonView: some View {
        Button {
            controller.sudoku.deleteAction()
        } label: {
            _bulidButtonView(systemName: "pencil.slash", textString: "删除")
                .padding([.horizontal])
        }
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
                    //.fixedSize()
            }
            
        }
    }
}
