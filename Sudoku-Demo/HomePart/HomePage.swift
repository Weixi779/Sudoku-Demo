//
//  HomePage.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/4/23.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var controller: AppController

    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            UserInfoView()
            Spacer()
            Text("Sudoku")
                .font(.system(size: 60))
                .bold()
                .foregroundColor(.gray.opacity(0.8))
            Spacer()
            if (controller.sudoku.isShowButton) {
                SudokuContinueButton(tabSelection:  $tabSelection)
            }
            SudokuCreateButton(tabSelection: $tabSelection)
        }
        .padding([.vertical])
    }
}

struct UserInfoView: View {
    @EnvironmentObject var controller: AppController
    @State var isShowSheet = false
    @State var tempText = ""
    
    var userInfo: UserInfo {
        controller.sudoku.userInfo
    }
    
    var progressValue: Int {
        userInfo.experience - userInfo.NextLevelExperience(userInfo.level-1)
    }
    
    var progressTotal: Int {
        userInfo.NextLevelExperience(userInfo.level) - userInfo.experience
    }
    
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
                        Text(userInfo.userName)
                        Spacer()
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                isShowSheet = true
                            }
                    }
                    .padding(.bottom)
                    
                    ProgressView(value: Double(progressValue),
                                 total: Double(progressTotal)
                    )
                }
                .frame(height: 60)
            }
            .padding([.horizontal])
            .padding([.horizontal])
        }.sheet(isPresented: $isShowSheet) {
            VStack {
                
                HStack {
                    Text("?????????:")
                    TextField(userInfo.userName, text: $tempText) {
                        controller.sudoku.userInfo.EditUserName(tempText)
                        tempText = ""
                    }
                }
                .padding(.horizontal)
                Divider()
                
                HStack() {
                    Text("??????:")
                    Text("\(userInfo.level)")
                    Spacer()
                }
                .padding(.horizontal)
                Divider()
                
                HStack() {
                    Text("??????:")
                    Text("\(userInfo.experience)")
                    Spacer()
                }
                .padding(.horizontal)
                Divider()

                HStack() {
                    Text("??????????????????:")
                    Text("\(userInfo.NextLevelExperience(userInfo.level) - userInfo.experience)")
                    Spacer()
                }
                .padding(.horizontal)
                Divider()
            }
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
            Text("\(userInfo.level)")
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
                    Text("????????????")
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
                    Text("?????????")
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
        .confirmationDialog("???????????????", isPresented: $isPressed, titleVisibility: .visible) {
            Button("??????") {
                chooseSudokuDiff(.easy)
            }
            
            Button("??????") {
                chooseSudokuDiff(.normal)
            }
            
            Button("??????") {
                chooseSudokuDiff(.hard)
            }
            
            Button("??????") {
                chooseSudokuDiff(.unlimit)
            }
            
            Button("??????", role: .cancel) {
                
            }
        }
    }
    
    func chooseSudokuDiff(_ diff: Difficulty) {
        Task {
            await controller.dlx.setDiff(diff)
            controller.createNewSudoku()
        }
        tabSelection = 2
    }
}
//struct HomePage_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePage()
//    }
//}
