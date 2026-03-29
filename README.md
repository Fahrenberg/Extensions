# Swift - Extensions - Library

![](https://img.shields.io/badge/iOS%20:-14-blue)
![](https://img.shields.io/badge/macOS%20:-11_(BigSur)-green)
![GitHub Release](https://img.shields.io/github/v/release/Fahrenberg/Extensions)
![GitHub last commit](https://img.shields.io/github/last-commit/Fahrenberg/Extensions)




# Character Set
- allCharacters
- removeWhitespaceAndNewLines

---------------------------------------------------
# Core Graphics
- CGSize Extension:
    Adding CGSize operators +,-,* returns CGSize

---------------------------------------------------
# Date    
> ###  ISO8601 conversion
> 
> ISO 8601 is a standard for representing dates and times, but it does not include provisions for daylight saving adjustments. Instead, ISO 8601 typically represents time in Coordinated Universal Time (UTC), which does not observe daylight saving time.
> 
> However, ISO 8601 **does allow for the representation of local time** with an offset from UTC. For example, "2024-05-06T12:00:00+02:00" represents noon on May 6, 2024, in a time zone with a UTC offset of +02:00. This offset may change due to daylight saving time, but **ISO 8601 itself doesn't dictate how daylight saving time should be handled**.

## DateFormatter "Helpers"
- defaultDateFormatter
- timeOnlyDateFormatter
- listDateFormatter

## TimeInterval
- unixTimeToDateString

## ExcelDate
- excelDateString
- excelDateSerialNumber

> ### Converting Date into a Excel Date Serial Number.
> - Date must be current time zone adjusted.
> - Excel's date/time is in terms of the local time on the computer. It does NOT use the timezone information.
> - Count starts at one (1-Jan-1900 = 1).
> - Excel include the non-existent 29-Feb-1900, Excel incorrectly assumes that the year 1900 is a leap year.
>  - Returns: Date Serial Number must be ``Double``
>  - Another bug fix method: start with 1.3.1900 as "first day" = 0  and add 60 days
> 
>  Links:
> - [Stackoverflow - Excel Time Zone](https://stackoverflow.com/questions/46010958/is-excel-date-value-time-zone-specific)
> - [Microsoft LeapYear 1900]( https://learn.microsoft.com/en-US/office/troubleshoot/excel/wrongly-assumes-1900-is-leap-year)
> - [Excel DATEVALUE function]( https://support.microsoft.com/en-us/office/datevalue-function-df8b07d4-7761-4a93-bc33-b7471bbff252)
> <br/> 

---------------------------------------------------
# FileManager
- directoryExists(directory: URL) ->  Bool
- fileExists(file: URL) -> Bool
- documentDirectory() -> URL
- cloudDirectory() -> URL
- isProtectedDirectory(_ directory: URL) -> Bool
- createDirectory(directory: URL) throws
- deleteAllFiles(directoryURL: URL = FileManager.documentDirectory()) -> Int
- countFiles(directoryURL: URL) -> Int
- directoryFileSize(directoryURL: URL) -> Int64 
- fileSize(url: URL) throws -> Int64 
---------------------------------------------------
# ByteCountFormatter
Conversion of Int, Int64, UInt64 to String formatted to kB, MB
- Int.outputKBytes: String 
- Int.outputMBytes: String
---------------------------------------------------
# String
- isNumber
- removeWhitespaceAndNewLines 
- String: LocalizedError (throw "any string you want")

---------------------------------------------------
# PlatformColor
- `PlatformColor` device independent color, either UIColor (UIKit, iOS)  NSColor (AppKit, macOS).
- Use HexColor (String) to get or set hex colors.
- Make Color Codable:  init(from: decoder), encode(to: Encoder).

- Color <-> Hex Converter:
    - Color(hexColor: HexColor) e.g. Color(hexColor: "#f1c5d93f").
    - Color(hex:UInt), e.g. Color(hex: 0xffc5d9AA).
    - Color.intColor returns integer value of the color (RGBA) or nil.
    - Color.hexColor returns HexColor (String) of color in RGBA, always with alpha = FF if no alpha in Color. FatalError if not valid CGColor components (shading etc., not use case for conversion).

- HexColor(String)
    - hexColor: String? returns a valid formatted HexColor in uppercase or nil if string cannot be converted to a hex color.
    - func isValidHexColor() -> Bool checks if the hex string is a valid hex color (ignores the leading `#`).
   
---------------------------------------------------
# PlatformImage
- `PlatformImage` device independent color, either UIImage (UIKit, iOS)  NSImage(AppKit, macOS).
- `var sizeDescription: String` returns formatted size of image (w: x h:).
- `func writeToDisk(filename: String) throws -> URL` writes PlatformImage to temporary folder. The temporary folder is platform dependent and will bei logged with OSLog. Returns URL to the created file.
- `func addFrame(frameWidth: CGFloat = 2.0, frameColor: PlatformColor = .red)  -> PlatformImage`adds a rectangle line around the image. The image will not be resize, return image ist frameWidth x 2 wider and higher than the original image.
- `public func fillFrame(frameColor: PlatformColor = .lightGray)  -> PlatformImage` fills any transparent pixels in the image with frameColor.

---------------------------------------------------
# SwiftUI
- DragGesture.Value - debugPrintGesture (Debugging)
- hideKeyboard (only for *iOS*)
- isHidden

