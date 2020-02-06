import Foundation

struct DateUtil {
    static func string2Date(dateString: String) -> Date {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        return dateFormatter.date(from: dateString)!
    }
    
    static func date2String(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.string(from: date)
    }
    
    static func isAfterDay(dateString: String) -> Bool {
        let standardDate = DateUtil.string2Date(dateString: dateString)
        let diff = standardDate.timeIntervalSince(Date())
        let dayDiff = diff / 86400
        
        return dayDiff >= 1
    }
}
