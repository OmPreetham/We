//
//  DateExtension.swift
//  We
//
//  Created by Om Preetham Bandi on 10/20/24.
//

import Foundation

extension Date {
    func relativeDate() -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: self)
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else if calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear) {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"
            return weekdayFormatter.string(from: self)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: self)
        }
    }
}
