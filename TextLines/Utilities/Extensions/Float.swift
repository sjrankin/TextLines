//
//  Float.swift
//  Float
//
//  Created by Stuart Rankin on 7/19/21.
//

import Foundation
import UIKit

// MARK: - CGFloat extensions.

extension Float
{
    /// Returns a rounded value of the instance Float.
    /// - Note:
    ///     - This "rounding" is nothing more than truncation.
    /// - Parameter Count: Number of places to round to.
    /// - Returns: Rounded value.
    func RoundedTo(_ Count: Int) -> Float
    {
        let Multiplier = pow(10.0, Count)
        let Value = Int(self * Float(Double(truncating: Multiplier as NSNumber)))
        return Float(Value) / Float(Double(truncating: Multiplier as NSNumber))
    }
    
    /// Converts the instance value from (an assumed) degrees to radians.
    /// - Returns: Value converted to radians.
    func ToRadians() -> Float
    {
        return self * Float.pi / 180.0
    }
    
    /// Converts the instance value from (an assumed) radians to degrees.
    /// - Returns: Value converted to degrees.
    func ToDegrees() -> Float
    {
        return self * 180.0 / Float.pi
    }
    
    /// Converts the instance value from assumed degrees to radians.
    /// - Returns: Value converted to radians.
    var Radians: Float
    {
        get
        {
            return ToRadians()
        }
    }
    
    /// Converts the instance value from assumed radians to degrees.
    /// - Returns: Value converted to degrees.
    var Degrees: Float
    {
        get
        {
            return ToDegrees()
        }
    }
    
    /// Return the square of the instance value.
    var Squared: Float
    {
        get
        {
            return self * self
        }
    }
    
    /// Return the cube of the instance value.
    var Cubed: Float
    {
        get
        {
            return self * self * self
        }
    }
}
