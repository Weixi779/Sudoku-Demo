//
//  DifficultySelectorView.swift
//  Sudoku-Demo
//
//  Created by weixi on 2025/8/17.
//

import SwiftUI
import ComposableArchitecture

struct DifficultySelectorView: View {
    let store: StoreOf<DifficultySelectorFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 24) {
                Button(action: {
                    viewStore.send(.showSelector)
                }) {
                    createSelectorView(viewStore)
                }
                .scaleEffect(viewStore.isPresented ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: viewStore.isPresented)
            }
            .padding()
            .confirmationDialog(
                "选择游戏难度",
                isPresented: viewStore.binding(
                    get: \.isPresented,
                    send: { _ in .hideSelector }
                ),
                titleVisibility: .visible
            ) {
                createDialogView(viewStore)
            } message: {
                Text("请选择适合您的游戏难度")
            }
        }
    }
    
    @ViewBuilder
    func createSelectorView(_ viewStore: ViewStoreOf<DifficultySelectorFeature>) -> some View {
        HStack(spacing: 0) {
            Text("难度: \(viewStore.selectedTitle)")
                .font(.body)
                .fontWeight(.medium)
                .frame(alignment: .leading)
            
            Text(" - \(viewStore.selectedInfoLabel)")
                .font(.caption)
                .opacity(0.8)
                .lineLimit(1)
            
            Spacer(minLength: 8)
            
            Image(systemName: "chevron.up.chevron.down")
                .font(.caption)
                .opacity(0.7)
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
                .stroke(Color(.systemGray4), lineWidth: 0.5)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
    
    @ViewBuilder
    func createDialogView(_ viewStore: ViewStoreOf<DifficultySelectorFeature>) -> some View {
        ForEach(viewStore.availableDifficulties) { difficulty in
            Button(difficulty.title) {
                viewStore.send(.difficultySelected(difficulty))
            }
        }
        
        Button("取消", role: .cancel) {
            viewStore.send(.cancelSelection)
        }
    }
}

#Preview {
    DifficultySelectorView(
        store: Store(initialState: DifficultySelectorFeature.State()) {
            DifficultySelectorFeature()
        }
    )
}
