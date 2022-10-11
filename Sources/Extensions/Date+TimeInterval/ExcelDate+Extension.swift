//
//  ExcelDate+Extension.swift
//  Created by Jean-Nicolas on 10.10.22.
//

import Foundation

extension Date {
    /**
     Convert Date into a Excel Date Serial Number.
     Date is current time zone adjusted.
    
     
     1: Excel's date/time is in terms of the local time on the computer. It does NOT use the timezone information.
     
     2: Count starts at one (1-Jan-1900 = 1).

     3: Excel include the non-existent 29-Feb-1900. See: Excel incorrectly assumes that the year 1900 is a leap year.
     
     Links:
     - [Stackoverflow - Excel Time Zone](https://stackoverflow.com/questions/46010958/is-excel-date-value-time-zone-specific)
     - [Microsoft LeapYear 1900]( https://learn.microsoft.com/en-US/office/troubleshoot/excel/wrongly-assumes-1900-is-leap-year)
     - [Excel DATEVALUE function]( https://support.microsoft.com/en-us/office/datevalue-function-df8b07d4-7761-4a93-bc33-b7471bbff252)
     
     - Returns: Date Serial Number as ``Double``
     
     - Note: [Excel Sheet to get Date Serial Number](https://www.icloud.com/iclouddrive/02dTgEOm0wGXd9o5B9fvVlsZQ#ExcelDateValue).
     - Note: Another bug fix method: start with 1.3.1900 as "first day" = 0  and add 60 days ....
     */
    public var excelDateValue: Double {
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
}
