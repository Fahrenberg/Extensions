
// --------------------------------------------------------------------------------------
// ----------------------------   View - Extensions   ---------------------------------
// --------------------------------------------------------------------------------------

import SwiftUI

extension View {
  
    /** Hide or show the view based on a boolean value.
    
    Example for visibility:
    ````
    Text("Label")
        .isHidden(true)
    ````
    Example for complete removal:
    ````
    Text("Label")
        .isHidden(true, remove: true)
    ````
    - Remark:
     The source code is available on GitHub here: [George-J-E/HidingViews](https://github.com/George-J-E/HidingViews)
     
  
    
    - See also:  [Dynamically hiding view in SwiftUI](https://www.thetopsites.net/article/59228385.shtml)
     
    - Parameter hidden: Set to `false` to show the view. Set to `true` to hide the view.
    - Parameter remove: Boolean value indicating whether or not to remove the view.
    
   
     */
    public func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        modifier(HiddenModifier(isHidden: hidden, remove: remove))
    }
}


/// Creates a view modifier to show and hide a view.
///
/// Variables can be used in place so that the content can be changed dynamically.
fileprivate struct HiddenModifier: ViewModifier {

    private let isHidden: Bool
    private let remove: Bool

    init(isHidden: Bool, remove: Bool = false) {
        self.isHidden = isHidden
        self.remove = remove
    }

    func body(content: Content) -> some View {
        Group {
            if isHidden {
                if remove {
                    EmptyView()
                } else {
                    content.hidden()
                }
            } else {
                content
            }
        }
    }
}

