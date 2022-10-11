// --------------------------------------------------------------------------------------
// -------------------------   DateFormatter - Extensions -------------------------------
// --------------------------------------------------------------------------------------


import Foundation

/**
 Default Datumsanzeige
 */
public let defaultDateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = .current
    formatter.dateStyle = .short  //Set date style dd.mm.yyy
    formatter.timeStyle = .short //Set time style hh:mm
    return formatter
}()
/**
 Default Datumsanzeige ohne Zeit
 */
public let defaultDateOnlyFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = .current
    formatter.dateStyle = .short  //Set date style dd.mm.yyy
    formatter.timeStyle = .none //Set time style hh:mm
    return formatter
}()



/**
 Default Zeitanzeige
 */
public let timeOnlyDateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = .current
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
    
}()
/// Datumsanzeige in Kurzform für Listendarstellung (e.g. dd.mm.)
///
/// See Stackoverflow ["Date according to currentLocale, without Year"](https://stackoverflow.com/questions/18767330/nsdateformatter-date-according-to-currentlocale-without-year/42561749#42561749)
public let listDateFormatter : DateFormatter = {
    let template = "dMM"
    let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale.current)
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter
}()
