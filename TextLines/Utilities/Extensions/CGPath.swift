//
//  CGPath.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/24/21.
//

import Foundation
import UIKit

extension CGPath
{
    /// Returns the points in the instance `CGPath`.
    /// - Note: See [How to get of points from a UIBezierPath](https://stackoverflow.com/questions/3051760/how-to-get-a-list-of-points-from-a-uibezierpath)
    /// - Returns: Array of points in the instance `CGPath`.
    func Points() -> [CGPoint]
    {
        var BezierPoints = [CGPoint]()
//        self.forEach(body: { (element: CGPathElement) in
            self.forEach2
            {
                (element: CGPathElement) in
            let numberOfPoints: Int =
            {
                switch element.type
                {
                    case .moveToPoint, .addLineToPoint: // contains 1 point
                        return 1
                    case .addQuadCurveToPoint: // contains 2 points
                        return 2
                    case .addCurveToPoint: // contains 3 points
                        return 3
                    case .closeSubpath:
                        return 0
                    default:
                        Debug.FatalError("Unexpected element type: \(element.type)")
                }
            }()
            for index in 0 ..< numberOfPoints
            {
                let point = element.points[index]
                BezierPoints.append(point)
            }
        }
        return BezierPoints
    }
}
