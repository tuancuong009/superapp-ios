//
//  DateExtensions.swift
//  CircleCue
//
//  Created by QTS Coder on 10/16/20.
//

import Foundation

extension Date {
    
    var firstDayOfWeek: Date {
        var beginningOfWeek = Date()
        var interval = TimeInterval()
        
        _ = Calendar.current.dateInterval(of: .weekOfYear, start: &beginningOfWeek, interval: &interval, for: self)
        return beginningOfWeek
    }
    
    func addWeeks(_ numWeeks: Int) -> Date {
        var components = DateComponents()
        components.weekOfYear = numWeeks
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func weeksAgo(_ numWeeks: Int) -> Date {
        return addWeeks(-numWeeks)
    }
    
    func addDays(_ numDays: Int) -> Date {
        var components = DateComponents()
        components.day = numDays
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func daysAgo(_ numDays: Int) -> Date {
        return addDays(-numDays)
    }
    
    func addHours(_ numHours: Int) -> Date {
        var components = DateComponents()
        components.hour = numHours
        
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    func hoursAgo(_ numHours: Int) -> Date {
        return addHours(-numHours)
    }
    
    func addMinutes(_ numMinutes: Double) -> Date {
        return self.addingTimeInterval(60 * numMinutes)
    }
    
    func minutesAgo(_ numMinutes: Double) -> Date {
        return addMinutes(-numMinutes)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        let cal = Calendar.current
        var components = DateComponents()
        components.day = 1
        return cal.date(byAdding: components, to: self.startOfDay)!.addingTimeInterval(-1)
    }
    
    var zeroBasedDayOfWeek: Int? {
        let comp = Calendar.current.component(.weekday, from: self)
        return comp - 1
    }
    
    func hoursFrom(_ date: Date) -> Double {
        return Double(Calendar.current.dateComponents([.hour], from: date, to: self).hour!)
    }
    
    func daysBetween(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self.startOfDay, to: date.startOfDay)
        
        return components.day!
    }
    
    var percentageOfDay: Double {
        let totalSeconds = self.endOfDay.timeIntervalSince(self.startOfDay) + 1
        let seconds = self.timeIntervalSince(self.startOfDay)
        let percentage = seconds / totalSeconds
        return max(min(percentage, 1.0), 0.0)
    }
    
    var numberOfWeeksInMonth: Int {
        let calendar = Calendar.current
        let weekRange = (calendar as NSCalendar).range(of: NSCalendar.Unit.weekOfYear, in: NSCalendar.Unit.month, for: self)
        
        return weekRange.length
    }
    
    func toDateString(_ dateFormat: AppDateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
    
    func toDateString(_ dateFormat: String, timezone: TimeZone?) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        if let timezone = timezone {
            formatter.timeZone = timezone
        }
        return formatter.string(from: self)
    }
    
    func toAlbumDate() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let dayString = formatter.string(from: self)
//
//        let day = Calendar.current.component(.day, from: self)
//        switch day {
//        case 1, 11, 21, 31:
//            dayString += "st"
//        case 2, 12, 22:
//            dayString += "nd"
//        case 3, 13, 23:
//            dayString += "rd"
//        default:
//            dayString += "th"
//        }
//
        return dayString
    }
    
    func getElapsedTime() -> String? {
        let compoments = Calendar.current.dateComponents([.second, .minute, .hour], from: self, to: Date())
        if let hours = compoments.hour {
            if hours >= 24 {
                return self.toDateString(.addNote)
            }
            if hours > 0 {
                return "\(hours)h"
            }
        }
        
        if let minute = compoments.minute {
            if minute > 1 {
                return "\(minute)min"
            }
        }
        
        if let seconds = compoments.second {
            if seconds > 10 {
                return "\(seconds)sec"
            }
            
            return "Just now"
        }
        
        return nil
    }
}
