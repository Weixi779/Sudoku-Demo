//
//  HomePage.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/4/23.
//

import SwiftUI

struct HomePage: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            UserInfo()
            Spacer()
            Text("Sudoku")
                .font(.system(size: 60))
                .bold()
                .foregroundColor(.gray.opacity(0.8))
            Spacer()
            SudokuContinueButton(tabSelection: $tabSelection)
            SudokuCreateButton(tabSelection: $tabSelection)
        }
        .padding([.vertical])
    }
}

struct UserInfo: View {
    @EnvironmentObject var controller: AppController
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .padding([.horizontal])
                .frame(height: 80)
                .shadow(radius: 5)

            
            HStack {
                ZStack {
                    avator
                    levelCircle
                }
                
                VStack {
                    HStack {
                        Text("Player")
                        Spacer()
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                // TODO: Profile 编辑
                            }
                    }
                    .padding(.bottom)
                    ProgressView(value: 25, total: 100)
                }
                .frame(height: 60)
            }
            .padding([.horizontal])
            .padding([.horizontal])
        }
        
    }
    
    var avator: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.blue)
                .frame(width: 60 ,height: 60)
            
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
        }
    }
    
    var levelCircle: some View {
        ZStack {
            Circle()
                .frame(width: 20, height: 20, alignment: .topTrailing)
                .foregroundColor(.red)
            Text("1")
                .foregroundColor(.white)
        }
        .offset(x: 25, y: 25)
    }
}

struct SudokuContinueButton: View {
    @EnvironmentObject var controller: AppController
    @Binding var tabSelection: Int

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 200,height: 40)
                    .foregroundColor(.blue.opacity(0.9))
                    .shadow(radius: 5)
                VStack {
                    Text("继续游戏")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.top)
                    
                    HStack{
                        Text("\(controller.sudoku.diffDescription)")
                        Text("-")
                        Text("\(controller.sudoku.timerCounter.time)")
                    }
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(.bottom)
                    
                }
                .frame(height: 30)
            }
        }
        .onTapGesture {
            tabSelection = 2
        }
        .shadow(radius: 5)
            
    }
}

struct SudokuCreateButton: View {
    @EnvironmentObject var controller: AppController
    @Binding var tabSelection: Int
    @State var isPressed = false
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 200,height: 40)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                VStack {
                    Text("新游戏")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
                .frame(height: 30)
                .padding(.vertical)
            }
        }
        .onTapGesture {
            isPressed.toggle()
        }
        .confirmationDialog("请选择难度", isPresented: $isPressed, titleVisibility: .visible) {
            Button("简单") {
                Task {
                    await controller.dlx.setDiff(.easy)
                    controller.createNewSudoku()
                }
                tabSelection = 2
            }
            
            Button("普通") {
                Task {
                    await controller.dlx.setDiff(.normal)
                    controller.createNewSudoku()
                }
                tabSelection = 2
            }
            
            Button("困难") {
                Task {
                    await controller.dlx.setDiff(.hard)
                    controller.createNewSudoku()
                }
                tabSelection = 2
            }
            
            Button("地狱") {
                Task {
                    await controller.dlx.setDiff(.unlimit)
                    controller.createNewSudoku()
                }
                tabSelection = 2
            }
            
            Button("取消", role: .cancel) {
                
            }
        }
    }
}
//struct HomePage_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePage()
//    }
//}
