//
//  Geometry.swift
//
//  Created by Luka on 27. 08. 14.
//  Copyright (c) 2014 lvnyk
//
//  Modifiedy by Stuart Rankin, 2021.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import UIKit

// MARK: - calculations
// MARK: CGPoint
func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint
{
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func +=(lhs: inout CGPoint, rhs: CGPoint)
{
    lhs.x += rhs.x
    lhs.y += rhs.y
}

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint
{
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func -=(lhs: inout CGPoint, rhs: CGPoint)
{
    lhs.x -= rhs.x
    lhs.y -= rhs.y
}

func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint
{
    return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}

func *=(lhs: inout CGPoint, rhs: CGFloat)
{
    lhs.x *= rhs
    lhs.y *= rhs
}

func *(lhs: CGFloat, rhs: CGPoint) -> CGPoint
{
    return CGPoint(x: rhs.x * lhs, y: rhs.y * lhs)
}

func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint
{
    return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
}

func /=(lhs: inout CGPoint, rhs: CGFloat)
{
    lhs.x /= rhs
    lhs.y /= rhs
}

func +(lhs: CGPoint, rhs: CGVector) -> CGPoint
{
    return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}

func -(lhs: CGPoint, rhs: CGVector) -> CGPoint
{
    return CGPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
}

prefix func -(lhs: CGPoint) -> CGPoint
{
    return CGPoint(x: -lhs.x, y: -lhs.y)
}

// MARK: CGVector
func +(lhs: CGVector, rhs: CGVector) -> CGVector
{
    return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

func +=(lhs: inout CGVector, rhs: CGVector)
{
    lhs.dx += rhs.dx
    lhs.dy += rhs.dy
}

func -(lhs: CGVector, rhs: CGVector) -> CGVector
{
    return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}

func -=(lhs: inout CGVector, rhs: CGVector)
{
    lhs.dx -= rhs.dx
    lhs.dy -= rhs.dy
}

func *(lhs: CGVector, rhs: CGFloat) -> CGVector
{
    return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
}

func *=(lhs: inout CGVector, rhs: CGFloat)
{
    lhs.dx *= rhs
    lhs.dy *= rhs
}

func *(lhs: CGFloat, rhs: CGVector) -> CGVector
{
    return CGVector(dx: rhs.dx * lhs, dy: rhs.dy * lhs)
}

func /(lhs: CGVector, rhs: CGFloat) -> CGVector
{
    return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
}

func /=(lhs: inout CGVector, rhs: CGFloat)
{
    lhs.dx /= rhs
    lhs.dy /= rhs
}

// MARK: CGSize
func +(lhs: CGSize, rhs: CGSize) -> CGSize
{
    return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

func +=(lhs: inout CGSize, rhs: CGSize)
{
    lhs.width += rhs.width
    lhs.height += rhs.height
}

func -(lhs: CGSize, rhs: CGSize) -> CGSize
{
    return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
}

func -=(lhs: inout CGSize, rhs: CGSize)
{
    lhs.width -= rhs.width
    lhs.height -= rhs.height
}

func *(lhs: CGFloat, rhs: CGSize) -> CGSize
{
    return CGSize(width: rhs.width * lhs, height: rhs.height * lhs)
}

func *(lhs: CGSize, rhs: CGFloat) -> CGSize
{
    return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}

func *=(lhs: inout CGSize, rhs: CGFloat)
{
    lhs.width *= rhs
    lhs.height *= rhs
}

func /(lhs: CGSize, rhs: CGFloat) -> CGSize
{
    return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
}

func /=(lhs: inout CGSize, rhs: CGFloat)
{
    lhs.width /= rhs
    lhs.height /= rhs
}

// MARK: CGRect
func *(lhs: CGRect, rhs: CGFloat) -> CGRect
{
    return CGRect(origin: lhs.origin * rhs, size: lhs.size * rhs)
}

func *(lhs: CGFloat, rhs: CGRect) -> CGRect
{
    return CGRect(origin: lhs * rhs.origin, size: lhs * rhs.size)
}

func *=(lhs: inout CGRect, rhs: CGFloat)
{
    lhs.origin *= rhs
    lhs.size *= rhs
}

func /(lhs: CGRect, rhs: CGFloat) -> CGRect
{
    return CGRect(origin: lhs.origin / rhs, size: lhs.size / rhs)
}

func /=(lhs: inout CGRect, rhs: CGFloat)
{
    lhs.origin /= rhs
    lhs.size /= rhs
}

func +(lhs: CGRect, rhs: CGPoint) -> CGRect
{
    return lhs.offsetBy(dx: rhs.x, dy: rhs.y)
}

func -(lhs: CGRect, rhs: CGPoint) -> CGRect
{
    return lhs.offsetBy(dx: -rhs.x, dy: -rhs.y)
}

func +(lhs: CGRect, rhs: CGSize) -> CGRect
{
    return CGRect(origin: lhs.origin, size: lhs.size + rhs)
}

func -(lhs: CGRect, rhs: CGSize) -> CGRect
{
    return CGRect(origin: lhs.origin, size: lhs.size - rhs)
}

// MARK: - helpers

/// Determines whether the second vector is above > 0 or below < 0 the first one
func *(lhs: CGPoint, rhs: CGPoint ) -> CGFloat
{
    return lhs.x * rhs.y - lhs.y * rhs.x
}

/// smallest angle between 2 angles
func arcFi( _ fi1: CGFloat, fi2: CGFloat ) -> CGFloat
{
    let p = CGPoint(x: cos(fi1) - cos(fi2), y: sin(fi1) - sin(fi2))
    let dSqr = p.x * p.x + p.y * p.y
    let fi = acos(1 - dSqr / 2)
    return fi
}

/// whether fi2 is larger than fi1 in reference to the ref angle
func compareAngles( _ ref: CGFloat, fi1: CGFloat, fi2: CGFloat ) -> CGFloat
{
    return -arcFi(ref, fi2: fi1) + arcFi(ref, fi2: fi2)
}

/// intersection

func lineIntersection( segmentStart p1:CGPoint, segmentEnd p2:CGPoint,
                       lineStart p3:CGPoint, lineEnd p4:CGPoint,
                       insideSegment: Bool = true, lineIsSegment: Bool = false,
                       hardUpperLimit: Bool = false ) -> CGPoint?
{
    let parallel = CGFloat(p1.x - p2.x) * CGFloat(p3.y-p4.y) -
    CGFloat(p1.y - p2.y) * CGFloat(p3.x - p4.x) == 0
    
    if parallel == false
    {
        let x: CGFloat = CGFloat(CGFloat(CGFloat(p1.x * p2.y) -
                                         CGFloat(p1.y * p2.x)) *
                                 CGFloat(p3.x - p4.x) -
                                 CGFloat(p1.x - p2.x) *
                                 CGFloat(CGFloat(p3.x * p4.y) -
                                         CGFloat(p3.y * p4.x))) /
        CGFloat(CGFloat(p1.x - p2.x) *
                CGFloat(p3.y - p4.y) -
                CGFloat(p1.y - p2.y) *
                CGFloat(p3.x - p4.x))
        let y: CGFloat = CGFloat(CGFloat(CGFloat(p1.x * p2.y) -
                                         CGFloat(p1.y * p2.x)) *
                                 CGFloat(p3.y - p4.y) -
                                 CGFloat(p1.y - p2.y) *
                                 CGFloat(CGFloat(p3.x * p4.y) -
                                         CGFloat(p3.y * p4.x))) /
        CGFloat(CGFloat(p1.x - p2.x) *
                CGFloat(p3.y - p4.y) -
                CGFloat(p1.y - p2.y) *
                CGFloat(p3.x - p4.x))
        let intersection = CGPoint(
            x: x,
            y: y
        )
        
        if insideSegment {
            let u = p2.x == p1.x ? 0 : (intersection.x - p1.x) / (p2.x - p1.x)
            let v = p2.y == p1.y ? 0 : (intersection.y - p1.y) / (p2.y - p1.y)
            
            if u < 0 || v < 0 || v > 1 || u > 1 || hardUpperLimit && (v >= 1 || u >= 1)
            {
                return nil
            }
            
            if lineIsSegment {
                let w = p4.x == p3.x ? 0 : (intersection.y - p3.x) / (p4.x - p3.x)
                let x = p4.y == p3.y ? 0 : (intersection.y - p3.y) / (p4.y - p3.y)
                
                if w < 0 || x < 0 || w > 1 || x > 1 || hardUpperLimit && (w >= 1 || x >= 1)
                {
                    return nil
                }
            }
        }
        
        return intersection
    }
    
    return nil
}


func segmentsIntersection(_ segment1: (CGPoint, CGPoint), _ segment2: (CGPoint, CGPoint)) -> CGPoint?
{
    return lineIntersection(segmentStart: segment1.0, segmentEnd: segment1.1, lineStart: segment2.0, lineEnd: segment2.1,
                            insideSegment: true, lineIsSegment: true, hardUpperLimit: true)
}

/// center of circle through points

func circleCenter(_ p0: CGPoint, p1: CGPoint, p2: CGPoint) -> CGPoint?
{
    let p01 = (p0 + p1) / 2 // midpoint
    let p12 = (p1 + p2) / 2
    
    let t01 = p1 - p0 // parallel -> tangent
    let t12 = p2 - p1
    
    let LI = lineIntersection(segmentStart: p01,
                              segmentEnd: p01 + CGPoint(x: -t01.y, y: t01.x),
                              lineStart: p12,
                              lineEnd: p12 + CGPoint(x: -t12.y, y: t12.x),
                              insideSegment: false)
    
    return LI
}

// MARK: - extensions

extension CGFloat
{
    static let Pi = CGFloat.pi
    static let Pi2 = CGFloat.pi / 2
    
    static let Phi = CGFloat(1.618033988749894848204586834)
    
    static func random(_ d:CGFloat = 1) -> CGFloat
    {
        return CGFloat(arc4random()) / CGFloat(UInt32.max) * d
    }
}

extension CGRect
{
    var topLeft: CGPoint
    {
        return CGPoint(x: self.minX, y: self.minY)
    }
    
    var topRight: CGPoint
    {
        return CGPoint(x: self.maxX, y: self.minY)
    }
    
    var bottomLeft: CGPoint
    {
        return CGPoint(x: self.minX, y: self.maxY)
    }
    
    var bottomRight: CGPoint
    {
        return CGPoint(x: self.maxX, y: self.maxY)
    }
    
    var topMiddle: CGPoint
    {
        return CGPoint(x: self.midX, y: self.minY)
    }
    
    var bottomMiddle: CGPoint
    {
        return CGPoint(x: self.midX, y: self.maxY)
    }
    
    var middleLeft: CGPoint
    {
        return CGPoint(x: self.minX, y: self.midY)
    }
    
    var middleRight: CGPoint
    {
        return CGPoint(x: self.maxX, y: self.midY)
    }
    
    var center: CGPoint
    {
        return CGPoint(x: self.midX, y: self.midY)
    }
    
    func transformed(_ t: CGAffineTransform) -> CGRect
    {
        return self.applying(t)
    }
    
    public func insetWith(_ insets: UIEdgeInsets) -> CGRect
    {
        return self.inset(by: insets)
    }
}

extension CGPoint
{
    static func Add(_ OldPoint: CGPoint, X: CGFloat, Y: CGFloat) -> CGPoint
    {
        let NewPoint = CGPoint(x: OldPoint.x + X, y: OldPoint.y + Y)
        return NewPoint
    }
    
    static func Multiply(_ OldPoint: CGPoint, X: CGFloat, Y: CGFloat) -> CGPoint
    {
        let NewPoint = CGPoint(x: OldPoint.x * X, y: OldPoint.y * Y)
        return NewPoint
    }
    
    /// distance to another point
    func distanceTo(_ point: CGPoint) -> CGFloat
    {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
    
    func integral() -> CGPoint
    {
        return CGPoint(x: round(self.x), y: round(self.y))
    }
    
    mutating func integrate()
    {
        self.x = round(self.x)
        self.y = round(self.y)
    }
    
    func transformed(_ t: CGAffineTransform) -> CGPoint
    {
        return self.applying(t)
    }
    
    func normalized() -> CGPoint
    {
        if self == .zero
        {
            return CGPoint(x: 1, y: 0)
        }
        return self / self.distanceTo(.zero)
    }
}

extension CGVector
{
    init(point: CGPoint)
    {
        self.init()
        self.dx = point.x
        self.dy = point.y
    }
    
    init(size: CGSize)
    {
        self.init()
        self.dx = size.width
        self.dy = size.height
    }
    
    var length: CGFloat
    {
        return sqrt(self.dx * self.dx + self.dy * self.dy)
    }
}

extension CGPoint
{
    init(vector: CGVector)
    {
        self.init()
        self.x = vector.dx
        self.y = vector.dy
    }
}

extension CGSize
{
    func integral() -> CGSize
    {
        var s = self
        s.integrate()
        return s
    }
    
    mutating func integrate()
    {
        self.width = round(self.width)
        self.height = round(self.height)
    }
}
