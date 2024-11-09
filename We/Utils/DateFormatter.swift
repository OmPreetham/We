//
//  DateFormatter.swift
//  We
//
//  Created by Om Preetham Bandi on 11/9/24.
//

import Foundation

let customISO8601Formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()
