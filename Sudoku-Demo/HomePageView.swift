//
//  ContentView.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//

import SwiftUI

struct HomePageView: View {
    @State private var tabSelection = 1
    var body: some View {
        TabView(selection: $tabSelection) {
            HomePage(tabSelection: $tabSelection)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("主页")
                }.tag(1)
            
            SudokuPageView(tabSelection: $tabSelection)
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("游戏")
                }.tag(2)
            
            RecordView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("更多")
                }.tag(3)
        }
    }
}
