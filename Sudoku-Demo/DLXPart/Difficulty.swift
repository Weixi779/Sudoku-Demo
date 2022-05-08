//
//  Difficulty.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/5/4.
//

import Foundation

enum Difficulty : CaseIterable, Identifiable, Codable {
    var id: Self { self }
    
    case easy, normal, hard, unlimit
}

extension Difficulty {
    func diffDescription() -> String {
        switch (self) {
        case.easy: return "简单"
        case.normal: return "普通"
        case.hard: return "困难"
        case.unlimit: return "无限制"
        }
    }
    
    func unkownCount() -> Int {
        switch (self) {
        case.easy: return Int.random(in: 10..<16)
        case.normal: return Int.random(in: 25..<33)
        case.hard: return Int.random(in: 40..<50)
        case.unlimit: return -1
        }
    }
}
