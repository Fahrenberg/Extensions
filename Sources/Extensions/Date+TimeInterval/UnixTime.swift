// --------------------------------------------------------------------------------------
// -------------------------   TimeInterval - Extensions -------------------------------
// --------------------------------------------------------------------------------------

import  Foundation

extension TimeInterval {
    /**
     Zeigt eine [Unix-Zeit](https://de.wikipedia.org/wiki/Unixzeit) als String-Datum ([mittleres Format](https://developer.apple.com/documentation/foundation/dateformatter)) mit der gewählten Spracheregion und der aktuellen Zeitzone an. Die Unix-Zeit misst die Zeit in Sekunden seit dem 1. Januar 1970, 00:00 Uhr UTC
     
     Siehe auch: Webapp mit [TimeStamp-Converter](https://www.unixtimestamp.com)
     
     ## Examples ##
     
     *Mit "Regional Setting":*
     ````
     let unixTime = 1596465725
     let current_locale = "de_CH"
     let dateString = unixTimeToDateString(dt: unixTime, languageCode: current_locale)
     print(dateString)
     ````
     Output:
     03.08.2020, 16:42
     ***
     *Default Regional Setting (en_US):*
     
     ````
     let unixTime = 1596465725
     let dateDefaultString = unixTimeToDateString(dt: unixTime)
     print(dateDefaultString)
     ````
     Output:
     Aug 3, 2020 at 4:42 PM
     
     - Parameters:
     - dt: Unix-Time (Sekunden), ohne Kommastellen!
     - languageCode: (optional) Sprachwahl gemäss [ISO 639-1](https://www.andiamo.co.uk/resources/iso-language-codes/)
     
     - Returns: *String* mit Datum und Zeit gemäss Regional Setting
     
     */
    public func unixTimeToDateString(languageCode:String = Locale.current.identifier ) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: languageCode)
        dateFormatter.timeZone = .current
        
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style hh:mm
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style dd.mm.yyy
        
        return dateFormatter.string(from: date)
        
    }
}
