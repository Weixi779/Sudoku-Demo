//
//  DifficultySelectorFeatureTests.swift
//  Sudoku-DemoTests
//
//  Created by weixi on 2025/8/17.
//

import Testing
import ComposableArchitecture
@testable import Sudoku_Demo

struct DifficultySelectorFeatureTests {
    
    // MARK: - Basic State Tests
    
    @Test func initialState() {
        let state = DifficultySelectorFeature.State()
        
        #expect(state.selectedDifficulty == nil)
        #expect(state.isPresented == false)
        #expect(state.availableDifficulties == GameDifficulty.allCases)
    }
    
    // MARK: - Action Tests
    
    @Test func showSelector() async {
        let store = await TestStore(initialState: DifficultySelectorFeature.State()) {
            DifficultySelectorFeature()
        }
        
        await store.send(.showSelector) {
            $0.isPresented = true
        }
    }
    
    @Test func hideSelector() async {
        let store = await TestStore(
            initialState: DifficultySelectorFeature.State(
                isPresented: true  // Start with selector shown
            )
        ) {
            DifficultySelectorFeature()
        }
        
        await store.send(.hideSelector) {
            $0.isPresented = false
        }
    }
    
    @Test func cancelSelection() async {
        let store = await TestStore(
            initialState: DifficultySelectorFeature.State(
                isPresented: true
            )
        ) {
            DifficultySelectorFeature()
        }
        
        await store.send(.cancelSelection) {
            $0.isPresented = false
        }
    }
    
    @Test func selectDifficulty() async {
        let store = await TestStore(
            initialState: DifficultySelectorFeature.State(
                isPresented: true
            )
        ) {
            DifficultySelectorFeature()
        }
        
        await store.send(.difficultySelected(.easy)) {
            $0.selectedDifficulty = .easy
            $0.isPresented = false
        }
    }
    
    // MARK: - User Flow Tests
    
    @Test func completeUserFlow() async {
        let store = await TestStore(initialState: DifficultySelectorFeature.State()) {
            DifficultySelectorFeature()
        }
        
        // User opens difficulty selector
        await store.send(.showSelector) {
            $0.isPresented = true
        }
        
        // User selects hard difficulty
        await store.send(.difficultySelected(.hard)) {
            $0.selectedDifficulty = .hard
            $0.isPresented = false
        }
    }
    
    @Test func userCancelsSelection() async {
        let store = await TestStore(initialState: DifficultySelectorFeature.State()) {
            DifficultySelectorFeature()
        }
        
        // User opens difficulty selector
        await store.send(.showSelector) {
            $0.isPresented = true
        }
        
        // User cancels without selecting
        await store.send(.cancelSelection) {
            $0.isPresented = false
            // selectedDifficulty remains nil
        }
        
        await #expect(store.state.selectedDifficulty == nil)
    }
}
