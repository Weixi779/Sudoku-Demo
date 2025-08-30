//
//  GameDifficulty.swift
//  Sudoku-Demo
//
//  Created by weixi on 2025/8/17.
//

import Foundation

enum GameDifficulty: CaseIterable, Identifiable, Codable {
    case easy, normal, hard, unlimited
    
    var id: Self { self }
    
    // MARK: - Display Properties
    
    var title: String {
        switch self {
        case .easy: return "简单"
        case .normal: return "普通"
        case .hard: return "困难"
        case .unlimited: return "地狱"
        }
    }
    
    var infoLabel: String {
        switch self {
        case .easy: return "10-15个空格"
        case .normal: return "25-32个空格"
        case .hard: return "40-49个空格"
        case .unlimited: return "完全空白"
        }
    }
    
    // MARK: - Game Logic Properties
    
    var emptySlotCount: Int {
        switch self {
        case .easy: return Int.random(in: 10...15)
        case .normal: return Int.random(in: 25...32)
        case .hard: return Int.random(in: 40...49)
        case .unlimited: return 81
        }
    }
    
    var experienceReward: Int {
        switch self {
        case .easy: return 10
        case .normal: return 25
        case .hard: return 50
        case .unlimited: return 100
        }
    }
}
