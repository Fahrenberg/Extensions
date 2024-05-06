// --------------------------------------------------------------------------------------
// -------------------------   KeyBoard View - Extensions -------------------------------
// --------------------------------------------------------------------------------------


import SwiftUI


#if canImport(UIKit)
import UIKit
extension View {
    /**
    Keyboard Dismiss for any view
    - See also: [Medium : SwiftUI Dismiss Keyboard on outside tap](https://medium.com/@realhouseofcode/swiftui-dismiss-keyboard-on-outside-tap-d3d56894813)
    */
   public func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

