//
//  String+Ext.swift
//  learnuikit
//
//  Created by chuanpham on 04/09/2024.
//

import Foundation

extension String {
    func convertToDate() -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current

        if let date = dateFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"

            return dateFormatter.string(from: date)
        } else {
            // Handle the case where the ISO string is invalid
            print("Invalid ISO date string")
            return "Unknown date"
        }
    }
}
