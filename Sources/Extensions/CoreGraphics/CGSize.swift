//
//  File.swift
//  
//
//  Created by Jean-Nicolas on 25.07.21.
//

import CoreGraphics


extension CGSize {
   /// Addition of two CGSize
   ///     Extension for CGSize
    public static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        let addedWidth = lhs.width + rhs.width
        let addedHeight = lhs.height + rhs.height
        return CGSize(width: addedWidth, height: addedHeight)
    }
    
    /// Substraction of two CGSize
    ///     Extension for CGSize
    public static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
         let substractedWidth = lhs.width - rhs.width
         let subtractedHeight = lhs.height - rhs.height
         return CGSize(width: substractedWidth, height: subtractedHeight)
     }
    
  
    /// Scale/Multiply CGSize by CGFloat
    /// Change rhs to generic Number
    public static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        let factor = rhs
        let multipliedWidth = lhs.width * factor
        let mulitpliedHeight = lhs.height * factor
        return CGSize(width: multipliedWidth, height: mulitpliedHeight)
    }
}

