//
//  +Spiral.swift
//  +Spiral
//
//  Adapted by Stuart Rankin on 8/23/21.
//
//  https://github.com/mabdulsubhan/UIBezierPath-Spiral/blob/master/UIBezierPath%2BSpiral.swift
//
//  UIBezierPath+Spiral.swift
//  Glow
//
//  Created by Muhammad Abdul Subhan on 14/07/2018.
//  Copyright © 2018 subhan. All rights reserved.
//
//  Generates a UIBezierPath approximation of an arithmetic spiral
//  Swift version of https://github.com/ZevEisenberg/ZESpiral
//
import Foundation
import UIKit

extension UIBezierPath {
    
    /// Line intersection determination (done via slope - if the slopes are equal, the intersect -
    /// this is sufficient for our purposes).
    static private func DoesIntersect(m1: CGFloat, m2: CGFloat) -> Bool
    {
        return m1 != m2
    }
    
    /// Create and return a spiral bezier path.
    /// - Warning: If `ThetaStep` is equal to `0.0`, a fatal error is thrown.
    /// - Parameters:
    ///   - center: Center point of the spiral.
    ///   - StartRadius: Start distance from the center of the spiral.
    ///   - LoopGap: Space/gap between each loop.
    ///   - StartTheta: Starting theta value.
    ///   - SndTheta: Ending theta value.
    ///   - ThetaStep: Advance step value for each iteration of theta. **Must not** be `0.0`. If the
    ///                value passed is `0.0`, a fatal error is thrown.
    ///   - Square: If true, a square "spiral" is drawn. If false, a round spiral (as expected by the
    ///             user) is drawn.
    /// - Returns: `UIBezierPath` of the spiral. nil returned on error.
    static func CreateSpiralPath(Center: CGPoint,
                                 StartRadius: CGFloat,
                                 LoopGap: CGFloat,
                                 StartTheta: CGFloat,
                                 EndTheta: CGFloat,
                                 ThetaStep: CGFloat,
                                 Square: Bool) -> UIBezierPath?
    {
        if Square
        {
            let SBezier = UIBezierPath()
            let SquareGap = LoopGap * UIConstants.DefaultSpiralGap
            var Points = [CGPoint]()
            let CenterX = CGFloat(Settings.GetInt(.ViewportWidth)) / 2.0
            let CenterY = CGFloat(Settings.GetInt(.ViewportHeight)) / 2.0
            var GapCount = 1.0
            let Fit = CGFloat(min(Settings.GetInt(.ViewportWidth),
                                  Settings.GetInt(.ViewportHeight)))
            let Top = CenterY - (Fit / 2.0)
            let Bottom = CenterY + (Fit / 2.0)
            let Right = CenterX + (Fit / 2.0)
            while true
            {
                var GapSize = GapCount * SquareGap
                if GapSize > (Fit / 2.0)
                {
                    break
                }
                
                //top
                Points.append(CGPoint(x: GapSize, y: GapSize))
                Points.append(CGPoint(x: Right - GapSize, y: GapSize))
                
                //right
                Points.append(CGPoint(x: Right - GapSize, y: Bottom - GapSize))
                
                //bottom
                let OldGapSize = GapSize
                GapCount = GapCount + 1.0
                GapSize = GapCount * SquareGap
                if GapSize > (Fit / 2.0)
                {
                    break
                }
                Points.append(CGPoint(x: GapSize, y: Bottom - OldGapSize))
                
                //left
                Points.append(CGPoint(x: GapSize, y: Top + GapSize))
            }
            if Settings.GetBool(.SpiralSquareSmooth)
            {
                Points = Chaikin.SmoothPoints(Points: Points,
                                              Iterations: UIConstants.SmoothingIterations,
                                              Closed: false)
            }
            SBezier.move(to: Points[0])
            for OtherPoint in Points
            {
                SBezier.addLine(to: OtherPoint)
            }
            return SBezier
        }
        
        if ThetaStep == 0.0
        {
            Debug.FatalError("ThetaStep is 0.0.")
        }
        let a = StartRadius     // Start distance from center
        let b = LoopGap         // Space between each loop
        
        let path = UIBezierPath()
        
        var OldTheta = StartTheta
        var NewTheta = StartTheta
        
        var OldR = a + b * OldTheta
        var NewR = a + b * NewTheta
        
        var OldPoint = CGPoint.zero
        var NewPoint = CGPoint.zero
        
        var OldSlope = CGFloat.greatestFiniteMagnitude
        var NewSlope = CGFloat.greatestFiniteMagnitude
        
        
        NewPoint.x = Center.x + OldR * cos(OldTheta)
        NewPoint.y = Center.y + OldR * sin(OldTheta)
        
        path.move(to: NewPoint)     // Moving to initial point
        var FirstSlope = true
        
        while OldTheta < EndTheta - ThetaStep
        {
            OldTheta = NewTheta
            NewTheta += ThetaStep
            
            OldR = NewR
            NewR = a + b * NewTheta
            
            OldPoint.x = NewPoint.x
            OldPoint.y = NewPoint.y
            NewPoint.x = Center.x + NewR * cos(NewTheta)
            NewPoint.y = Center.y + NewR * sin(NewTheta)
            
            // Slope calculation with the formula:
            // (b * sinΘ + (a + bΘ) * cosΘ) / (b * cosΘ - (a + bΘ) * sinΘ)
            let APlusBTheta = a + (b * NewTheta)
            
            if FirstSlope
            {
                OldSlope = ((b * sin(OldTheta) + (APlusBTheta * cos(OldTheta))) /
                            (b * cos(OldTheta) - (APlusBTheta * sin(OldTheta))))
                FirstSlope = false
            }
            else
            {
                OldSlope = NewSlope
            }
            
            NewSlope = (b * sin(NewTheta) + (APlusBTheta * cos(NewTheta))) /
                       (b * cos(NewTheta) - APlusBTheta * sin(NewTheta))
            
            var ControlPoint = CGPoint.zero
            
            let OldIntercept = -(OldSlope * OldR * cos(OldTheta) -
                                 (OldR * sin(OldTheta)))
            let NewIntercept = -(NewSlope * NewR * cos(NewTheta) -
                                 (NewR * sin(NewTheta)))
            
            let Intersects = DoesIntersect(m1: OldSlope, m2: NewSlope)
            
            if Intersects
            {
                let OutX = (NewIntercept - OldIntercept) / (OldSlope - NewSlope)
                let OutY = OldSlope * OutX + OldIntercept
                
                ControlPoint.x = OutX
                ControlPoint.y = OutY
                
            }
            else
            {
                Debug.Print("These lines should never be parallel")
                //return nil
            }
            
            // Offset the control point by the center offset.
            ControlPoint.x += Center.x
            ControlPoint.y += Center.y
            
            path.addQuadCurve(to: NewPoint, controlPoint: ControlPoint)
        }
        
        return path
    }
}
