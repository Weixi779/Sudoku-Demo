//
//  Sudoku_DemoApp.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/2/11.
//

import SwiftUI

@main
struct Sudoku_DemoApp: App {
    @StateObject var controller = AppController()
    var body: some Scene {
        WindowGroup {
            HomePageView().environmentObject(controller)
        }
    }
}
