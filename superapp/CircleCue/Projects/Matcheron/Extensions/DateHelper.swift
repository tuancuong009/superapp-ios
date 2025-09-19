//
//  DateHelper.swift
//  platstack
//

import UIKit

class DateHelper {
    static func timeAgoTwoDate(_ date: Date)-> String{
        let currentDate = Date()
        let between = currentDate.timeIntervalSince1970 - date.timeIntervalSince1970
        if between < 44 {
            return "a few seconds ago"
        }
        else if between == 44 {
            return "44 seconds ago"
        }
        else if between <= 89{
            return "a minute ago"
        }
        else if (between >= 90 && between < (45 * 60)){
            var minute = between/60
            minute.round()
            return "\(Int(minute)) minutes ago"
        }
        else if between < (90 * 60){
            return "an hour ago"
        }
        else if between < (22 * 60 * 60){
            var hour = between/3600
            hour.round()
            if hour < 22 {
                return "\(Int(hour)) hours ago"
            }
            return "a day ago"
        }
        else if between <= 35*60*60{
            return "a day ago"
        }
        else if between < (26 * 24 * 60 * 60){
            var day = between/86400
            day.round()
            if day < 26 {
                return "\(Int(day)) days ago"
            }
            return "a month ago"
        }
        else if between <= (45 * 24 * 60 * 60){
            return "a month ago"
        }
        else if between < (320 * 24 * 60 * 60){
            var month = between/2628000
            month.round()
            if month < 320 {
                return "\(Int(month)) months ago"
            }
            return "a year ago"
        }
        else if between <= (547 * 24 * 60 * 60){
            return "a year ago"
        }
        else{
            var year = between/31536000
            year.round()
            return "\(Int(year)) years ago"
        }
    }
   
    
    static func checkDateTime(_ number: TimeInterval)-> String{
        let between = number
        if between < 44 {
            return "a few seconds ago"
        }
        else if between == 44 {
            return "44 seconds ago"
        }
        else if between <= 89{
            return "a minute ago"
        }
        else if (between >= 90 && between < (45 * 60)){
            var minute = between/60
            minute.round()
            return "\(Int(minute)) minutes ago"
        }
        else if between < (90 * 60){
            return "an hour ago"
        }
        else if between < (22 * 60 * 60){
            var hour = between/3600
            hour.round()
            if hour < 22 {
                return "\(Int(hour)) hours ago"
            }
            return "a day ago"
        }
        else if between <= 35*60*60{
            return "a day ago"
        }
        else if between < (26 * 24 * 60 * 60){
            var day = between/86400
            day.round()
            if day < 26 {
                return "\(Int(day)) days ago"
            }
            return "a month ago"
        }
        else if between <= (45 * 24 * 60 * 60){
            return "a month ago"
        }
        else if between < (320 * 24 * 60 * 60){
            var month = between/2628000
            month.round()
            if month < 320 {
                return "\(Int(month)) months ago"
            }
            return "a year ago"
        }
        else if between <= (547 * 24 * 60 * 60){
            return "a year ago"
        }
        else{
            var year = between/31536000
            year.round()
            return "\(Int(year)) years ago"
        }
    }
}
extension Date {

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

}
