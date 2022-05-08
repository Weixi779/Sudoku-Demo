//
//  UserViewModel.swift
//  Sudoku-Demo
//
//  Created by yunzhanghu1186 on 2022/5/4.
//

import Foundation

struct UserInfo: Codable {
    public var userName: String = "Player"
    public var level: Int = 1
    public var experience: Int = 0
    
    private var _easyRecorder: Recorder = Recorder()
    private var _normalRecorder: Recorder = Recorder()
    private var _hardRecoder: Recorder = Recorder()
    private var _unlimitRecoder: Recorder = Recorder()
}

// -MARK: Current Picker Part
extension UserInfo {

    public func currentRecorder(_ currentDiff: Difficulty) -> Recorder {
        switch currentDiff {
        case .easy: return _easyRecorder
        case .normal: return _normalRecorder
        case .hard: return _hardRecoder
        case .unlimit: return _unlimitRecoder
        }
    }
    
    public mutating func AddExperience(_ diff: Difficulty) {
        switch diff {
        case .easy: self.experience += 1
        case .normal: self.experience += 2
        case .hard: self.experience += 3
        case .unlimit: self.experience += 4
        }
        IsLevelUp()
    }
    
    private mutating func IsLevelUp() {
        while experience >= NextLevelExperience(level) {
            level += 1
        }
    }
    
    public func NextLevelExperience(_ level: Int) -> Int {
        guard level > 0 else { return 0 }
        return level + NextLevelExperience(level - 1)
    }
    
    public mutating func EditUserName(_ newName: String) {
        userName = newName
    }
}
