//
//  +Animation.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/29/21.
//

import Foundation
import UIKit

extension ViewController
{
    /// Called periodically when animation is active to update the offset of the start of
    /// the text in relation to the Bezier path.
    @objc func HandleAnimation()
    {
        var Final: CGFloat = 0.0
        OperationQueue.main.addOperation
        {
            let Velocity = Double(Settings.GetInt(.AnimationSpeed) * 1)
            let Clockwise = Settings.GetBool(.AnimateClockwise)
            let Direction: Double = Clockwise ? 1 : -1
            var perm: Double = 0.0
            switch Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
            {
                case .Bezier:
                    perm = self.PathLength
                    Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                    if Final < 0.0
                    {
                        Final = perm - Final
                    }
                    if Final > perm
                    {
                        Final = 0
                    }
                    
                case .Ellipse:
                    let OvalWidth = Double(Settings.GetInt(.EllipseLength))
                    let OvalHeight = Double(Settings.GetInt(.EllipseHeight))
                    perm = Math.EllipseCircumference(Width: OvalWidth,
                                                     Height: OvalHeight)
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(perm / 2)) +
                        CGFloat((Velocity * Direction))
                    }
                    else
                    {
                        Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                        if Final < 0.0
                        {
                            Final = perm / 2 - Final
                        }
                    }
                    
                case .Circle:
                    let CircleDiameter = Double(Settings.GetInt(.CircleDiameter))
                    perm = Math.CircleCircumference(Radius: CircleDiameter)
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(perm / 2)) +
                        CGFloat((Velocity * Direction))
                    }
                    else
                    {
                        Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                        if Final < 0.0
                        {
                            Final = self.PathLength - Final
                        }
                    }
                    
                case .Rectangle:
                    perm = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(perm)) +
                        CGFloat((Velocity * Direction))
                    }
                    else
                    {
                        Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                        if Final < 0.0
                        {
                            Final = self.PathLength - Final
                        }
                    }
                    
                case .Triangle:
                    perm = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(perm)) +
                        CGFloat((Velocity * Direction))
                    }
                    else
                    {
                        Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                        if Final < 0.0
                        {
                            Final = self.PathLength - Final
                        }
                    }
                    
                case .Line:
                    perm = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(perm)) +
                        CGFloat((Velocity * Direction))
                    }
                    else
                    {
                        Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                        if Final < 0.0
                        {
                            Final = self.PathLength - Final
                        }
                    }
                    
                case .Hexagon, .Octagon:
                    perm = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(perm)) +
                        CGFloat((Velocity * Direction))
                    }
                    else
                    {
                        Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                        if Final < 0.0
                        {
                            Final = self.PathLength - Final
                        }
                    }
                    
                case .Spiral:
                    perm = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(perm)) +
                        CGFloat((Velocity * Direction))
                    }
                    else
                    {
                        Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                        if Final < 0.0
                        {
                            Final = self.PathLength - Final
                        }
                    }
                    
                case .Infinity:
                    perm = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(perm)) +
                        CGFloat((Velocity * Direction))
                    }
                    else
                    {
                        Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                        if Final < 0.0
                        {
                            Final = self.PathLength - Final
                        }
                    }
                    
                case .Heart:
                    perm = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(perm)) +
                        CGFloat((Velocity * Direction))
                    }
                    else
                    {
                        Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                        if Final < 0.0
                        {
                            Final = self.PathLength - Final
                        }
                    }
                    
                case .User:
                    perm = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(perm)) +
                        CGFloat((Velocity * Direction))
                    }
                    else
                    {
                        Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                        if Final < 0.0
                        {
                            Final = self.PathLength - Final
                        }
                    }
                    
                case .Scribble:
                    return
            }
            self.AnimationOffset = Final
            self.UpdateOutput()
        }
    }
    
}
