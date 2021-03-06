//
//  CGPoint.swift
//  TextLines
//
//  Created by Stuart Rankin on 10/17/21.
//

import Foundation
import UIKit

extension CGPoint
{
    // MARK: - CGPoint extensions.
    
    /// Rotate the instance point by the passed number of degrees and return a
    /// new `CGPoint` with the rotated point.
    /// - Parameter By: Number of **degrees** to rotate the point by.
    /// - Returns: New point rotated by the specified number of degrees.
    func Rotate(By Degrees: CGFloat) -> CGPoint
    {
        let Radians = Degrees.Radians
        let NewX = self.x * cos(Radians) - self.y * sin(Radians)
        let NewY = self.x * sin(Radians) + self.y * cos(Radians)
        return CGPoint(x: NewX, y: NewY)
    }
    
    func DistanceTo(Other Point: CGPoint) -> CGFloat
    {
        let DeltaX = self.x - Point.x
        let DeltaY = self.y - Point.y
        let DeltaX2 = DeltaX * DeltaX
        let DeltaY2 = DeltaY * DeltaY
        let Dist = sqrt(DeltaX2 + DeltaY2)
        return Dist
    }
}
