//
//  Math.swift
//  Math
//
//  Created by Stuart Rankin on 8/19/21.
//

import Foundation

class Math
{
    /// Returns the circumference of an ellipse.
    /// - Note: See [Ellipse Perimeter](https://www.mathsisfun.com/geometry/ellipse-perimeter.html)
    /// - Parameter Width: First axis. Assumed to be the long parameter but it doesn't really matter.
    /// - Parameter Height: Second axis. Assumed to be the short parameter but it doesn't really matter.
    /// - Returns: Circumference of the ellipse.
    public static func EllipseCircumference(Width A: Double, Height B: Double) -> Double
    {
        let Term1 = Double.pi
        let SubTerm1 = 3.0 * (A + B)
        let SubTerm2 = sqrt(((3 * A) + B) * (A + (3.0 * B)))
        let Term2 = SubTerm1 - SubTerm2
        let Final = Term1 * Term2
        return Final
    }
    
    /// Returns the circumference of a circle.
    /// - Parameter Radius: Radius of the circle whose circumference will be returned.
    /// - Returns: Circumference of the circle.
    public static func CircleCircumference(Radius: Double) -> Double
    {
        return Radius * 2 * Double.pi
    }
}
