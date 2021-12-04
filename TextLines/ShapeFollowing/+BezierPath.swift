//
//  +BezierPath.swift
//  +BezierPath
//
//  Created by Stuart Rankin on 8/21/21.
//

import Foundation
import UIKit
import CoreGraphics

//https://github.com/louisdh/bezierpath-length/tree/master/Source
public extension UIBezierPath {
    
    /// Length of path in points.
    var length: CGFloat
    {
        return cgPath.length
    }
    
    /// Get the point on the path at the given percentage
    /// - Parameter percent: Percentage of path, between 0.0 and 1.0 (inclusive)
    /// - Returns: Point on the path
    func point(at percent: CGFloat) -> CGPoint?
    {
        
        return cgPath.point(at: percent)
    }
}

public extension CGPath
{
    /// Length of path in points
    var length: CGFloat
    {
        return getLength(with: elements)
    }
    
    /// Get the point on the path at the given percentage
    /// - Parameter percent: Percentage of path, between 0.0 and 1.0 (inclusive)
    /// - Returns: Point on the path
    func point(at percent: CGFloat) -> CGPoint?
    {
        return point(at: percent, with: elements)
    }
}

extension CGPath
{
    // MARK: - Internal
    func point(at percent: CGFloat, with elements: [PathElement]) -> CGPoint?
    {
        if percent < 0.0 || percent > 1.0
        {
            return nil
        }
        
        let percentLength = length * percent
        var lengthTraversed: CGFloat = 0
        
        var firstPointInSubpath: CGPoint?
        
        /// Holds current point on the path (must never be a control point)
        var currentPoint: CGPoint?
        
        for e in elements
        {
            switch(e)
            {
                case let .move(to: p0):
                    currentPoint = p0
                    
                    if firstPointInSubpath == nil
                    {
                        firstPointInSubpath = p0
                    }
                    
                case let .addLine(to: p1):
                    
                    guard let p0 = currentPoint else
                    {
                        assertionFailure("Expected current point")
                        break
                    }
                    
                    let l = linearLength(p0: p0, p1: p1)
                    
                    if lengthTraversed + l >= percentLength
                    {
                        let lengthInSubpath = percentLength - lengthTraversed
                        let t = lengthInSubpath / l
                        return linearPoint(t: t, p0: p0, p1: p1)
                    }
                    lengthTraversed += l
                    currentPoint = p1
                    
                case let .addQuadCurve(c1, to: p1):
                    guard let p0 = currentPoint else
                    {
                        assertionFailure("Expected current point")
                        break
                    }
                    
                    let l = quadCurveLength(p0: p0, c1: c1, p1: p1)
                    if lengthTraversed + l >= percentLength
                    {
                        let lengthInSubpath = percentLength - lengthTraversed
                        let t = lengthInSubpath / l
                        return quadCurvePoint(t: t, p0: p0, c1: c1, p1: p1)
                    }
                    lengthTraversed += l
                    currentPoint = p1
                    
                case let .addCurve(c1, c2, to: p1):
                    guard let p0 = currentPoint else
                    {
                        assertionFailure("Expected current point")
                        break
                    }
                    
                    let l = cubicCurveLength(p0: p0, c1: c1, c2: c2, p1: p1)
                    if lengthTraversed + l >= percentLength
                    {
                        let lengthInSubpath = percentLength - lengthTraversed
                        let t = lengthInSubpath / l
                        return cubicCurvePoint(t: t, p0: p0, c1: c1, c2: c2, p1: p1)
                    }
                    lengthTraversed += l
                    currentPoint = p1
                    
                case .closeSubpath:
                    guard let p0 = currentPoint else
                    {
                        break
                    }
                    
                    if let p1 = firstPointInSubpath
                    {
                        let l = linearLength(p0: p0, p1: p1)
                        if lengthTraversed + l >= percentLength
                        {
                            let lengthInSubpath = percentLength - lengthTraversed
                            let t = lengthInSubpath / l
                            return linearPoint(t: t, p0: p0, p1: p1)
                        }
                        lengthTraversed += l
                        currentPoint = p1
                    }
                    firstPointInSubpath = nil
            }
        }
        return nil
    }
    
    func getLength(with elements: [PathElement]) -> CGFloat
    {
        var firstPointInSubpath: CGPoint?
        
        /// Holds current point on the path (must never be a control point)
        var currentPoint: CGPoint?
        var length: CGFloat = 0
        
        for e in elements
        {
            switch(e)
            {
                case let .move(to: p0):
                    currentPoint = p0
                    if firstPointInSubpath == nil
                    {
                        firstPointInSubpath = p0
                    }
                    
                case let .addLine(to: p1):
                    guard let p0 = currentPoint else
                    {
                        assertionFailure("Expected current point")
                        break
                    }
                    length += linearLength(p0: p0, p1: p1)
                    currentPoint = p1
                    
                case let .addQuadCurve(c1, to: p1):
                    guard let p0 = currentPoint else
                    {
                        assertionFailure("Expected current point")
                        break
                    }
                    
                    length += quadCurveLength(p0: p0, c1: c1, p1: p1)
                    currentPoint = p1
                    
                case let .addCurve(c1, c2, to: p1):
                    guard let p0 = currentPoint else
                    {
                        assertionFailure("Expected current point")
                        break
                    }
                    length += cubicCurveLength(p0: p0, c1: c1, c2: c2, p1: p1)
                    currentPoint = p1
                    
                case .closeSubpath:
                    guard let p0 = currentPoint else
                    {
                        break
                    }
                    
                    if let p1 = firstPointInSubpath
                    {
                        length += linearLength(p0: p0, p1: p1)
                        currentPoint = p1
                    }
                    firstPointInSubpath = nil
            }
            
        }
        
        return length
    }
    
    // MARK: - Linear
    func linearLength(p0: CGPoint, p1: CGPoint) -> CGFloat
    {
        return p0.distanceTo(p1)
    }
    
    func linearPoint(t: CGFloat, p0: CGPoint, p1: CGPoint) -> CGPoint
    {
        let x = linearValue(t: t, p0: p0.x, p1: p1.x)
        let y = linearValue(t: t, p0: p0.y, p1: p1.y)
        return CGPoint(x: x, y: y)
    }
    
    func linearValue(t: CGFloat, p0: CGFloat, p1: CGFloat) -> CGFloat
    {
        var value: CGFloat = 0.0
        
        // (1-t) * p0 + t * p1
        value += (1-t) * p0
        value += t * p1
        
        return value
        
    }
    
    // MARK: - Quadratic
    func quadCurveLength(p0: CGPoint, c1: CGPoint, p1: CGPoint) -> CGFloat
    {
        var approxDist: CGFloat = 0
        let approxSteps: CGFloat = 100
        
        for i in 0 ..< Int(approxSteps)
        {
            let t0 = CGFloat(i) / approxSteps
            let t1 = CGFloat(i+1) / approxSteps
            
            let a = quadCurvePoint(t: t0, p0: p0, c1: c1, p1: p1)
            let b = quadCurvePoint(t: t1, p0: p0, c1: c1, p1: p1)
            
            approxDist += a.distanceTo(b)
        }
        
        return approxDist
    }
    
    func quadCurvePoint(t: CGFloat, p0: CGPoint, c1: CGPoint, p1: CGPoint) -> CGPoint
    {
        let x = quadCurveValue(t: t, p0: p0.x, c1: c1.x, p1: p1.x)
        let y = quadCurveValue(t: t, p0: p0.y, c1: c1.y, p1: p1.y)
        
        return CGPoint(x: x, y: y)
    }
    
    func quadCurveValue(t: CGFloat, p0: CGFloat, c1: CGFloat, p1: CGFloat) -> CGFloat
    {
        var value: CGFloat = 0.0
        
        // (1-t)^2 * p0 + 2 * (1-t) * t * c1 + t^2 * p1
        value += pow(1-t, 2) * p0
        value += 2 * (1-t) * t * c1
        value += pow(t, 2) * p1
        
        return value
    }
    
    // MARK: - Cubic
    func cubicCurveLength(p0: CGPoint, c1: CGPoint, c2: CGPoint, p1: CGPoint) -> CGFloat
    {
        var approxDist: CGFloat = 0
        let approxSteps: CGFloat = 100
        
        for i in 0 ..< Int(approxSteps)
        {
            let t0 = CGFloat(i) / approxSteps
            let t1 = CGFloat(i+1) / approxSteps
            
            let a = cubicCurvePoint(t: t0, p0: p0, c1: c1, c2: c2, p1: p1)
            let b = cubicCurvePoint(t: t1, p0: p0, c1: c1, c2: c2, p1: p1)
            
            approxDist += a.distanceTo(b)
        }
        
        return approxDist
    }
    
    func cubicCurvePoint(t: CGFloat, p0: CGPoint, c1: CGPoint, c2: CGPoint, p1: CGPoint) -> CGPoint
    {
        let x = cubicCurveValue(t: t, p0: p0.x, c1: c1.x, c2: c2.x, p1: p1.x)
        let y = cubicCurveValue(t: t, p0: p0.y, c1: c1.y, c2: c2.y, p1: p1.y)
        
        return CGPoint(x: x, y: y)
    }
    
    func cubicCurveValue(t: CGFloat, p0: CGFloat, c1: CGFloat, c2: CGFloat, p1: CGFloat) -> CGFloat
    {
        var value: CGFloat = 0.0
        
        // (1-t)^3 * p0 + 3 * (1-t)^2 * t * c1 + 3 * (1-t) * t^2 * c2 + t^3 * p1
        value += pow(1-t, 3) * p0
        value += 3 * pow(1-t, 2) * t * c1
        value += 3 * (1-t) * pow(t, 2) * c2
        value += pow(t, 3) * p1
        
        return value
    }
}


/// Swifty version of `CGPathElement` & `CGPathElementType`
enum PathElement
{
    /// The path element that starts a new subpath. The element holds a single point for the destination.
    case move(to: CGPoint)
    
    /// The path element that adds a line from the current point to a new point. The element holds a single point for the destination.
    case addLine(to: CGPoint)
    
    /// The path element that adds a quadratic curve from the current point to the specified point. The element holds a control point and a destination point.
    case addQuadCurve(CGPoint, to: CGPoint)
    
    /// The path element that adds a cubic curve from the current point to the specified point. The element holds two control points and a destination point.
    case addCurve(CGPoint, CGPoint, to: CGPoint)
    
    /// The path element that closes and completes a subpath. The element does not contain any points.
    case closeSubpath
    
    init(element: CGPathElement)
    {
        switch element.type
        {
            case .moveToPoint:
                self = .move(to: element.points[0])
                
            case .addLineToPoint:
                self = .addLine(to: element.points[0])
                
            case .addQuadCurveToPoint:
                self = .addQuadCurve(element.points[0], to: element.points[1])
                
            case .addCurveToPoint:
                self = .addCurve(element.points[0], element.points[1], to: element.points[2])
                
            case .closeSubpath:
                self = .closeSubpath
                
            @unknown default:
                Debug.FatalError("Unkown bezier path element type \(element.type)")
        }
    }
}

extension CGPath
{
    typealias PathApplier = @convention(block) (UnsafePointer<CGPathElement>) -> Void
    
    func apply(with applier: @escaping PathApplier)
    {
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void =
        {
            (info, element) in
            let block = unsafeBitCast(info, to: PathApplier.self)
            block(element)
        }
        
        self.apply(info: unsafeBitCast(applier, to: UnsafeMutableRawPointer.self),
                   function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
    
    var elements: [PathElement]
    {
        var pathElements = [PathElement]()
        
        apply {
            (element) in
            let pathElement = PathElement(element: element.pointee)
            pathElements.append(pathElement)
        }
        
        return pathElements
    }
}
