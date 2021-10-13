//
//  Double.swift
//  Double
//
//  Created by Stuart Rankin on 7/18/21. Adapted from Flatland View.
//

import Foundation
import UIKit

// MARK: - Double extensions.

extension Double
{
    /// Returns a rounded value of the instance double.
    /// - Note:
    ///   - This "rounding" is nothing more than truncation.
    ///   - `NaN` values are returned as `0.0`.
    ///   - Infinite values are returned as `0.0`.
    /// - Parameter Count: Number of places to round to.
    /// - Parameter PadTo: If specified, the number of digits to pad the least significant portion to if less
    ///                    than `Count`.
    /// - Returns: Rounded value.
    func RoundedTo(_ Count: Int) -> Double
    {
        if self.isNaN
        {
            return 0.0
        }
        if self.isInfinite
        {
            return 0.0
        }
        let Multiplier = pow(10.0, Count)
        let Value = Int(self * Double(truncating: Multiplier as NSNumber))
        return Double(Value) / Double(truncating: Multiplier as NSNumber)
    }
    
    /// Returns a rounded value of the instance double as a string.
    /// - Note: This "rounding" is nothing more than truncation.
    /// - Parameter Count: Number of places to round to.
    /// - Parameter PadTo: If specified, the number of digits to pad the least significant portion to if less
    ///                    than `Count`.
    /// - Returns: Rounded value.
    func RoundedTo(_ Count: Int, PadTo: Int = 3) -> String
    {
        let Raw = self.RoundedTo(Count)
        let RawString = "\(Raw)"
        let Parts = RawString.split(separator: ".", omittingEmptySubsequences: true)
        let MostSignificant = String(Parts[0])
        var RawLeast = String(Parts[1])
        if RawLeast.count >= PadTo
        {
            return RawString
        }
        let Delta = PadTo - RawLeast.count
        for _ in 0 ..< Delta
        {
            RawLeast.append("0")
        }
        return "\(MostSignificant).\(RawLeast)"
    }
    
    /// Converts the instance value from (an assumed) degrees to radians.
    /// - Returns: Value converted to radians.
    func ToRadians() -> Double
    {
        return self * Double.pi / 180.0
    }
    
    /// Converts the instance value from (an assumed) radians to degrees.
    /// - Returns: Value converted to degrees.
    func ToDegrees() -> Double
    {
        return self * 180.0 / Double.pi
    }
    
    /// Converts the instance value from assumed degrees to radians.
    /// - Returns: Value converted to radians.
    var Radians: Double
    {
        get
        {
            return ToRadians()
        }
    }
    
    /// Converts the instance value from assumed radians to degrees.
    /// - Returns: Value converted to degrees.
    var Degrees: Double
    {
        get
        {
            return ToDegrees()
        }
    }
    
    /// Returns the instance value as a delimited string.
    /// - Parameter Delimiter: The character (or string if the caller prefers) to use to delimit thousands blocks.
    /// - Returns: Value as a character delimited string.
    func Delimited(Delimiter: String = ",") -> String
    {
        let Raw = "\(self)"
        let RawValue = self
        let Parts = Raw.split(separator: ".", omittingEmptySubsequences: true)
        let Leading = String(Parts[0])
        
        let Remainder = RawValue.truncatingRemainder(dividingBy: 1)
        let RS = "\(Remainder)"
        let RParts = RS.split(separator: ".")
        let Trailing = String(RParts[1])
        
        if Leading.count <= 3
        {
            return Raw
        }
        var RawArray = Array(Leading)
        var Working = ""
        while RawArray.count > 0
        {
            let Last3 = RawArray.suffix(3)
            var Sub = ""
            for C in Last3
            {
                Sub = Sub + String(C)
            }
            if RawArray.count >= 3
            {
                RawArray.removeLast(3)
            }
            else
            {
                RawArray.removeAll()
            }
            let Separator = RawArray.count > 0 ? Delimiter : ""
            Working = "\(Separator)\(Sub)" + Working
        }
        return "\(Working).\(Trailing)"
    }
    
    /// Return the square of the instance value.
    var Squared: Double
    {
        get
        {
            return self * self
        }
    }
    
    /// Return the cube of the instance value.
    var Cubed: Double
    {
        get
        {
            return self * self * self
        }
    }
}

