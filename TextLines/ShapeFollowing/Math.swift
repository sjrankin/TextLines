//
//  Math.swift
//  Math
//
//  Created by Stuart Rankin on 8/19/21.
//

import Foundation

class Math
{
    //https://www.mathsisfun.com/geometry/ellipse-perimeter.html
    public static func EllipseCircumference(Width A: Double, Height B: Double) -> Double
    {
        let Term1 = Double.pi
        let SubTerm1 = 3.0 * (A + B)
        let SubTerm2 = sqrt(((3 * A) + B) * (A + (3.0 * B)))
        let Term2 = SubTerm1 - SubTerm2
        let Final = Term1 * Term2
        return Final
    }
    
    public static func CircleCircumference(Radius: Double) -> Double
    {
        return Radius * 2 * Double.pi
    }
}
