//
//  DifficultySelectorFeature.swift
//  Sudoku-Demo
//
//  Created by weixi on 2025/8/17.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DifficultySelectorFeature {
    @ObservableState
    struct State: Equatable {
        var selectedDifficulty: GameDifficulty? = nil
        var isPresented: Bool = false
        var availableDifficulties: [GameDifficulty] = GameDifficulty.allCases
    }
    
    enum Action {
        case showSelector
        case hideSelector
        case difficultySelected(GameDifficulty)
        case cancelSelection
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .showSelector:
                state.isPresented = true
                return .none
                
            case .hideSelector, .cancelSelection:
                state.isPresented = false
                return .none
                
            case .difficultySelected(let difficulty):
                state.selectedDifficulty = difficulty
                state.isPresented = false
                return .none
                
            }
        }
    }
}

// MARK: - State Extensions

extension DifficultySelectorFeature.State {
    
    var selectedTitle: String {
        selectedDifficulty?.title ?? "未选择"
    }
    
    var selectedInfoLabel: String {
        selectedDifficulty?.infoLabel ?? "难度描述"
    }
}
