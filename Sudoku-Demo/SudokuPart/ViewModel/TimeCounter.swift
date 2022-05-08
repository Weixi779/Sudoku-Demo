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
            return TimerCounter.secondConvertTime(_seconds)
        }
    }
    
    public static func secondConvertTime(_ seconds: Int) -> String {
        guard seconds != Int.max else { return "00 : 00"}
        let timeMin = seconds / 60
        let mins = timeMin < 10 ? "0\(timeMin)" : "\(timeMin)"
        let timeSec = seconds % 60
        let secs = timeSec < 10 ? "0\(timeSec)" : "\(timeSec)"
        return "\(mins) : \(secs)"
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
    
    public func exportTime() -> Int {
        return _seconds
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
