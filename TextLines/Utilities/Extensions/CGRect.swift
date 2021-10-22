//
//  CGRect.swift
//  TextLines
//
//  Created by Stuart Rankin on 10/22/21.
//

import Foundation
import UIKit

extension CGRect
{
    /// Create a new `CGRect` from two points. Points are normalized such that the upper-left
    /// corner has the lowest value `x` and `y` values.
    /// - Parameter Point1 - First point.
    /// - Parameter Point2 - Second point.
    /// - Returns: New `CGRect` structure created from the two points. Depending on the points,
    ///            the returned size of the rectangle is from `0.0` upwards - no negative sizes
    ///            are returned.
    static func MakeRect(Point1: CGPoint, Point2 : CGPoint) -> CGRect
    {
        var P1: CGPoint = .zero
        var P2: CGPoint = .zero
        switch (Point1.x < Point2.x, Point1.y < Point2.y)
        {
            case (true, true):
                P1 = Point1
                P2 = Point2
                
            case (true, false):
                P1 = CGPoint(x: Point1.x, y: Point2.y)
                P2 = CGPoint(x: Point2.x, y: Point1.y)
                
            case (false, true):
                P1 = CGPoint(x: Point2.x, y: Point1.y)
                P2 = CGPoint(x: Point1.x, y: Point2.y)
                
            case (false, false):
                P1 = Point2
                P2 = Point1
        }
        let Width = abs(P1.x - P2.x)
        let Height = abs(P1.y - P2.y)
        let Final = CGRect(origin: P1, size: CGSize(width: Width, height: Height))
        return Final
    }
    
    /// Convenience function to determine if both the `width` and `height` of the
    /// instance rectangle are greater than zero.
    /// - Returns: True if both `width` and `height` are greater than `0.0`, false
    ///            otherwise.
    func NonZeroSize() -> Bool
    {
        return self.width > 0.0 && self.height > 0.0
    }
}
