//
//  SettingView.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/4/28.
//

import SwiftUI

struct RecordView: View {
    @EnvironmentObject var controller: AppController

    var recorder: Recorder {
        controller.sudoku.userInfo.currentRecorder(temp)
    }
    @State var temp : Difficulty = .easy
    var body: some View {
        Form {
            Section("统计信息") {
                Picker("diffSelection", selection: $temp) {
                    ForEach(Difficulty.allCases) { diff in
                        Text(diff.diffDescription())
                    }
                }
            }
            
            Section("游戏相关") {
                SectionShowItem(itemDescription: "游戏开始", record: "\(recorder.startCount)")
                SectionShowItem(itemDescription: "游戏获胜", record: "\(recorder.victoryCount)")
                SectionShowItem(itemDescription: "胜率", record: recorder.winRate)
                SectionShowItem(itemDescription: "错误次数", record: "\(recorder.wrongCount)")
                SectionShowItem(itemDescription: "零失误获胜", record: "\(recorder.perfectWin)")
            }
            
            Section("时间") {
                SectionShowItem(itemDescription: "最快时间", record: TimerCounter.secondConvertTime(recorder.fastestTime))
                SectionShowItem(itemDescription: "平均时间", record: TimerCounter.secondConvertTime(recorder.AverageTime()))
            }
        }
        .pickerStyle(.segmented)
        
    }
}

struct SectionShowItem: View {
    var itemDescription: String
    var record: String
    
    var body: some View {
        HStack {
            Text(itemDescription)
            Spacer()
            Text(record)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
