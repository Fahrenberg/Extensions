// --------------------------------------------------------------------------------------
// -------------------------   SwiftUI - DragGesture - Extensions -----------------------------
// --------------------------------------------------------------------------------------

import SwiftUI

extension DragGesture.Value {
   public func debugPrintGesture() {
        let horizontalSwipeSize = self.translation.width
        let verticalSwipeSize = self.translation.height
        
        let leftStartPosition = self.startLocation.x
        let topStartPosition = self.startLocation.y
        print("DragGesture.Value  left (x) =",leftStartPosition,"top (y) = ",topStartPosition, " swipe horizontal = ",horizontalSwipeSize, "swipe vertical = ", verticalSwipeSize )
    }
}

