# iOS/macOS - Extensions - Library


# Character Set
- allCharacters
- removeWhitespaceAndNewLines

---------------------------------------------------
# Core Graphics
- CGSize Extension:
    Adding CGSize operators +,-,* returns CGSize

---------------------------------------------------
# Date    

## DateFormatter "Helpers"
- defaultDateFormatter
- timeOnlyDateFormatter
- listDateFormatter
- excelDateString
- excelDateSerialNumber

## TimeInterval
- unixTimeToDateString

---------------------------------------------------
# FileManager
- directoryExists(directory: URL) ->  Bool
- documentDirectory() -> URL
- cloudDirectory() -> URL
- createDirectory(directory: URL)
- deleteAllFiles(directoryURL: URL = FileManager.documentDirectory()) -> Int
- countFiles(directoryURL: URL) -> Int
- directoryFileSize(directoryURL: URL) -> Int64 
- fileSize(url: URL) throws -> Int64 

---------------------------------------------------
# String
- isNumber
- removeWhitespaceAndNewLines 
- String: LocalizedError (throw "any string you want")

---------------------------------------------------
# SwiftUI
- DragGesture.Value - debugPrintGesture (Debugging)
- hideKeyboard (only for *iOS*)
- isHidden

---------------------------------------------------
### Notes for converting Date into a Excel Date Serial Number.

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

-----
### Notes for ISO8601 conversion

    ISO 8601 is a standard for representing dates and times, but it does not include provisions for daylight saving adjustments. Instead, ISO 8601 typically represents time in Coordinated Universal Time (UTC), which does not observe daylight saving time.

    However, ISO 8601 does allow for the representation of local time with an offset from UTC. For example, "2024-05-06T12:00:00+02:00" represents noon on May 6, 2024, in a time zone with a UTC offset of +02:00. This offset may change due to daylight saving time, but ISO 8601 itself doesn't dictate how daylight saving time should be handled.
-----------
