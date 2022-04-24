//
//  HomePage.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/4/23.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        VStack {
            UserInfo()
            SudokuContinueButton()
            SudokuCreateButton()
        }
    }
}

struct UserInfo: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.gray.opacity(0.5))
                .padding([.horizontal])
                .frame(height: 80)
            
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
                    Text("02:06-容易　")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .frame(height: 30)
                .padding(.vertical)
            }

        }
            
    }
}

struct SudokuCreateButton: View {
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
            Button("Blue") {
                print("Blue")
            }
            
            Button("取消", role: .cancel) {
                
            }
        }
    }
}
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
