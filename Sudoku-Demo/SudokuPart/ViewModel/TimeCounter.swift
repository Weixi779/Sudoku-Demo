//
//  TimeCounter.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/3/29.
//

import Foundation
import SwiftUI
/// 倒计时组件
/// 抽象一下功能
/*
 - 重置时间
 - 开始计时
 - +1S
 - 暂停计时
 - 导出时间
 */

struct TimerCounter: Codable{
    private var _seconds: Int = 0
    public var isCounting: Bool = false;
    var time: String {
        get {
            let timeMin = _seconds / 60
            let mins = timeMin < 10 ? "0\(timeMin)" : "\(timeMin)"
            let timeSec = _seconds % 60
            let secs = timeSec < 10 ? "0\(timeSec)" : "\(timeSec)"
            return "\(mins) : \(secs)"
        }
    }
    
    mutating func resetTime() {
        _seconds = 0
    }
    
    mutating func addOneSeconds() {
        if isCounting == true {
            _seconds += 1
        }
    }
    
    mutating func startCounting() {
        isCounting = true
    }
    
    mutating func stopCounting() {
        isCounting = false
    }
    
    public mutating func exportTime() -> String {
        stopCounting()
        return time
    }
    
    public func iconSystemName() -> String {
        return isCounting ? "pause.fill" : "play.fill"
    }
    
    public mutating func iconFunction() {
        if isCounting == true {
            stopCounting()
        } else {
            startCounting()
        }
    }
}
