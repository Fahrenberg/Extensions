// --------------------------------------------------------------------------------------
// -------------------------   Date to Excel / Numbers Conversion   ---------------------
// --------------------------------------------------------------------------------------


import Foundation

extension Date {
    ///  Convert Date into a Excel Date Serial Number.
    public var excelDateSerialNumber: Double {
        let calendar = Calendar.current
        let timeZone = calendar.timeZone
        let excelDateComponent = DateComponents(year: 1900, month: 01, day: 01, hour: 1, minute: 0) // use 1 hour ! not 0
        var excelDate = calendar.date(from: excelDateComponent)!
        /* adjust to excel by subtracting 2 days!
          - 1 day for "beginning of  1.1.1900"
          - 1 day because of wrong leap day 29.2.1900.
        */
        excelDate = calendar.date(byAdding: DateComponents(day:-2), to: excelDate)!
        let secondsInterval = DateInterval(start: excelDate, end: self).duration
        /* adjust for time zone */
        let secondsFromGmt = Double(timeZone.secondsFromGMT())
        let excelSecondsInterval = secondsInterval + secondsFromGmt
        let secondsToDay: Double = (60 * 60 * 24)
        return excelSecondsInterval / secondsToDay
    }

    /// Converting Date for Numbers or Excel CSV imports, date format is dd.mm.yyyy hh:mm:ss
    /// Using UTC GMT Time Zone
    /// No Daylight Saving Time adjustment
    ///
    /// Returns: String
    public var excelDateString: String {

    let formatter = DateFormatter()
    //    formatter.timeZone = TimeZone.gmt
    formatter.timeZone = TimeZone(identifier: "GMT")!
    formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    let dateString = formatter.string(from: self)
    return dateString
    }
    }
