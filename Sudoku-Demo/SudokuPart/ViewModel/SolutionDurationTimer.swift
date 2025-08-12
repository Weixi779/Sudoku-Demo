//
//  TimeCounter.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/3/29.
//

import Foundation
import Observation

@Observable
final class SolutionDurationTimer {
    private var seconds: TimeInterval = .zero
    
    private(set) var isCounting: Bool = false
    
    var displayTime: String { seconds.toFormattedTimeString }
    
    func resetTime() { seconds = 0 }
    
    func fireTimer() {
        seconds += 1
    }
    
    func startCounting() { isCounting = true }
    
    func stopCounting() { isCounting = false }
    
    public func exportTime() -> Int { Int(seconds) }
    
    func iconFunction() {
        if isCounting == true {
            stopCounting()
        } else {
            startCounting()
        }
    }
    
    var timerIcon: String {
        return isCounting ? "pause.fill" : "play.fill"
    }
}
