import Foundation

extension Date {
    var dateOrTimeRepresentation: String {
        let calender = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calender.isDateInToday(self) {
            dateFormatter.dateFormat = "h:mm a"
            let formattedDate = dateFormatter.string(from: self)
            return formattedDate
        } else if calender.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "MM/dd/yy"
            return dateFormatter.string(from: self)
        }
    }
    
    var formatToTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: self)
        
        return formattedTime
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    var relativeDateString: String {
        let calender = Calendar.current
        if calender.isDateInToday(self) {
            return "Today"
        } else if calender.isDateInYesterday(self) {
            return "Yesterday"
        } else if isCurrentWeek {
            return toString(format: "EEEE") /// Wednesday
        } else if isCurrentYear {
            return toString(format: "E, MMM d") /// Wed, Jan 29
        } else {
            return toString(format: "MMM dd, yyyy") /// Wed, Jan 29, 2025
        }
    }
    
    private var isCurrentWeek: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekday)
    }
    
    private var isCurrentYear: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
}
