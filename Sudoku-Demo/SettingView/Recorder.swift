//
//  Recorder.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/5/4.
//

import Foundation

class Recorder: Codable {
    public var startCount: Int = 0
    public var victoryCount: Int = 0
    public var winRate: String {
        let rate = Double(victoryCount) / Double(startCount)
        return startCount == 0 ? "-%" : "\(floor(rate*100))%"
    }
    public var wrongCount: Int = 0
    public var perfectWin: Int = 0
    public var fastestTime: Int = Int.max
    public var timeArray: [Int] = [Int]()
}

extension Recorder {
    func AddStartCount() {
        startCount += 1
    }
    
    func AddVicotryCount() {
        victoryCount += 1
    }
    
    func AddWrongCount(_ count: Int) {
        wrongCount += count
    }
    
    func AddPerfectWinCount() {
        perfectWin += 1
    }
    
    func AddTimeArray(_ second: Int) {
        timeArray.append(second)
        fastestTime = min(second, fastestTime)
    }
    
    func AverageTime() -> Int {
        guard timeArray.count > 0 else { return 0 }
        let sum = timeArray.reduce(0, {$0 + $1})
        return sum / timeArray.count
    }
}
