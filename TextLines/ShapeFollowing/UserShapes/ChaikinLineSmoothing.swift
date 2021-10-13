//
//  ChaikinLineSmoothing.swift
//  TextLine
//
//  Created by Stuart Rankin on 10/1/21.
//

import Foundation
import UIKit

/// Class that implements the Chaikin algorithm for line smoothing.
class Chaikin
{
    /// Smooth the passed set of points.
    /// - Note:
    ///    - Two consecutive points that have the same `x` or same `y` value will
    ///      result in a straight line.
    ///    - See [Chaikin's Algorithm](https://www.bit-101.com/blog/2021/08/chaikins-algorithm-drawing-curves/)
    /// - Parameter Points: The points to smooth.
    /// - Parameter Iterations: Number of iterations - more iterations results in smoother lines
    ///                         at the expense of performance. 5 is a reasonal number.
    /// - Parameter Closed: Flag that determines if the path is open (`false`) or
    ///                     closed (`true`).
    /// - Returns: Set of points that when drawn with lines, will be smoother looking than
    ///            using the original set of points.
    public static func SmoothPoints(Points: [CGPoint], Iterations Count: Int, Closed: Bool) -> [CGPoint]
    {
        var Working = Points
        for _ in 0 ..< Count
        {
            Working = Smooth(Points: Working, Closed: Closed)
        }
        return Working
    }
    
    /// Smooths lines in the passed set of points using Chaikin's algorithm.
    /// - Parameter Points: Set of points to smooth.
    /// - Parameter Closed: Determines if the shape is open (a line) or closed (a loop).
    /// - Returns: New set of points that when drawn with lines, is smoother.
    private static func Smooth(Points: [CGPoint], Closed: Bool) -> [CGPoint]
    {
        if Points.count <= 2
        {
            return Points
        }
        let First = Points.first!
        let Last = Points.last!
        var Path = [CGPoint]()
        if !Closed
        {
            Path.append(First)
        }
        let Percent = 0.25
        for Index in 0 ..< Points.count - 1
        {
            let P0 = Points[Index]
            let P1 = Points[Index + 1]
            let Dx = P1.x - P0.x
            let Dy = P1.y - P0.y
            Path.append(CGPoint(x: P0.x + Dx * Percent,
                                y: P0.y + Dy * Percent))
            Path.append(CGPoint(x: P0.x + Dx * (1.0 - Percent),
                                y: P0.y + Dy * (1.0 - Percent)))
        }
        if !Closed
        {
            Path.append(Last)
        }
        else
        {
            let Dx = First.x - Last.x
            let Dy = First.y - Last.y
            Path.append(CGPoint(x: Last.x + Dx * Percent,
                                y: Last.y + Dy * Percent))
            Path.append(CGPoint(x: Last.x + Dx * (1.0 - Percent),
                                y: Last.y + Dy * (1.0 - Percent)))
        }
        return Path
    }
}
