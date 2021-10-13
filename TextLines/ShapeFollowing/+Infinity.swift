//
//  +Infinity.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/27/21.
//

import Foundation
import UIKit

extension UIBezierPath
{
    static func CreateInfinityPath(LeftCenter: CGPoint,
                                   RightCenter: CGPoint,
                                   Radius: CGFloat,
                                   Width: CGFloat = 1.0) -> UIBezierPath?
    {
        let XDelta = (abs(RightCenter.x - LeftCenter.x) / 2) + LeftCenter.x
        let YDelta = (abs(RightCenter.y - LeftCenter.y) / 2) + LeftCenter.y
        let Path = UIBezierPath()
        let LeftArc = UIBezierPath(arcCenter: LeftCenter,
                                   radius: Radius,
                                   startAngle: CGFloat.pi / 2,
                                   endAngle: CGFloat.pi * 1.5,
                                   clockwise: true)
        
        let LeftToRight = UIBezierPath()
        LeftToRight.move(to: CGPoint(x: LeftCenter.x,
                                     y: LeftCenter.y - Radius))
        LeftToRight.addCurve(to: CGPoint(x: RightCenter.x,
                                         y: RightCenter.y + Radius),
                             controlPoint1: CGPoint(x: XDelta,
                                                    y: YDelta - Radius),
                             controlPoint2: CGPoint(x: XDelta,
                                                    y: YDelta + Radius))
        
        let RightArc = UIBezierPath(arcCenter: RightCenter,
                                    radius: Radius,
                                    startAngle: CGFloat.pi / 2,
                                    endAngle: CGFloat.pi * 1.5,
                                    clockwise: false)
        
        let RightToLeft = UIBezierPath()
        RightToLeft.move(to: CGPoint(x: RightCenter.x,
                                     y: RightCenter.y - Radius))
                         RightToLeft.addCurve(to: CGPoint(x: LeftCenter.x,
                                                          y: RightCenter.y + Radius),
                             controlPoint1: CGPoint(x: XDelta,
                                                    y: YDelta - Radius),
                             controlPoint2: CGPoint(x: XDelta,
                                                    y: YDelta + Radius))
        Path.append(LeftArc)
        Path.append(LeftToRight)
        Path.append(RightArc)
        Path.append(RightToLeft)
        
        Path.lineWidth = Width
        Path.lineJoinStyle = .round
        UIColor.systemYellow.setStroke()
        
        return Path
    }
}
