//
//  TimeInterval.swift
//  Sudoku-Demo
//
//  Created by weixi on 2025/8/1.
//

import Foundation

extension TimeInterval {
    
    /// Convert seconds to formatted time string (MM : SS)
    /// - Returns: Formatted time string in "MM : SS" format
    var toFormattedTimeString: String {
        guard self != TimeInterval.greatestFiniteMagnitude && !self.isInfinite else {
            return "00 : 00"
        }
        
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        let formattedMinutes = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let formattedSeconds = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        
        return "\(formattedMinutes) : \(formattedSeconds)"
    }
}
