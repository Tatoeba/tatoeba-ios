//
//  Date+Extensions.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Foundation

// MARK: - Date helper methods and variables
extension Date {
    
    /// Converts a date to a localized string using a date template.
    ///
    /// - Parameter template: A string containing the date format components to make use of.
    /// - Returns: The date as a localized string, using the passed components.
    func string(from template: String) -> String {
        let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale.current)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// This date's year as an integer
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /// This date's month (1-12) as an integer
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    /// This date's day of the month (1-31) as an integer
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /// A localized readable representation of this date
    var localizedDescription: String {
        let dateTemplate: String
        let timeTemplate: String
        
        if year == Date().year {
            // Weekday, month, day
            dateTemplate = "EEEE MMMM d"
            
            // Hour, minute, am/pm (if applicable)
            timeTemplate = "h mm j"
        } else {
            // Month, day, year
            dateTemplate = "MMMM d yyyy"
            
            // Hour, minute, am/pm (if applicable)
            timeTemplate = "h mm j"
        }
        
        let dateString = string(from: dateTemplate)
        let timeString = string(from: timeTemplate)
        
        return TatoebaLocalizer.localize("Contribution_Date", parameters: ["date": dateString, "time": timeString])
    }
}
