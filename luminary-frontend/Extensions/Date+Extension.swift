//
//  Date+Extension.swift
//  A3
//
//  Created by Vin Bui on 10/31/23.
//

import Foundation

extension Date {

    /**
     Returns a string representation of the amount of time from this date to now

     For example, if today is July 1 7:00 PM and this date was July 1 6:50 PM, this function returns `"10 min. ago"`
    */
    func convertToAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    
    func formattedTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a  •  MM/dd/yy"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        // Lowercase the AM/PM part
        let result = formatter.string(from: self)
        return result
    }
    
}
