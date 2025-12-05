//
//  Duration+Extension.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import Foundation

extension Duration {

    /// Returns a human-readable string (e.g. "5 hours, 3 minutes")
    func formattedHumanReadable() -> String {
        let totalSeconds = self.components.seconds
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60

        switch (hours, minutes) {
        case (let h, let m) where h > 0 && m > 0:
            return "\(h) \(h == 1 ? "hour" : "hours"), \(m) \(m == 1 ? "minute" : "minutes")"

        case (let h, _) where h > 0:
            return "\(h) \(h == 1 ? "hour" : "hours")"

        default:
            return "\(minutes) \(minutes == 1 ? "minute" : "minutes")"
        }
    }
    
    /// Returns a time string in "HH:MM" format (e.g., "07:32")
    func formattedHHMM() -> String {
        let totalSeconds = self.components.seconds
        let nonNegativeSeconds = max(0, totalSeconds)
        
        let hours = nonNegativeSeconds / 3600
        let minutes = (nonNegativeSeconds % 3600) / 60
        
        let formattedString = String(format: "%02d:%02d", hours, minutes)
        
        return formattedString
    }
}
