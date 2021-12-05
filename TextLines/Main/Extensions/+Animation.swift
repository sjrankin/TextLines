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
            var Perimeter: Double = 0.0
            switch Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
            {
                case .Ellipse:
                    var OvalWidth = Double(Settings.GetDoubleNormal(.EllipseMajor))
                    var OvalHeight = Double(Settings.GetDoubleNormal(.EllipseMinor))
                    OvalWidth = OvalWidth * Double(Settings.GetInt(.ViewportWidth))
                    OvalHeight = OvalHeight * Double(Settings.GetInt(.ViewportHeight))
                    Perimeter = Math.EllipseCircumference(Width: OvalWidth,
                                                     Height: OvalHeight)
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter / 2)) +
                        CGFloat((Velocity * Direction))
                    }
                    else
                    {
                        Final = CGFloat(self.AnimationOffset) + CGFloat(Velocity * Direction)
                        if Final < 0.0
                        {
                            Final = Perimeter / 2 - Final
                        }
                    }
                    
                case .Circle:
                    let CircleDiameter = Double(Settings.GetInt(.CircleDiameter))
                    Perimeter = Math.CircleCircumference(Radius: CircleDiameter)
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter / 2)) +
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
                    Perimeter = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter)) +
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
                    Perimeter = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter)) +
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
                    Perimeter = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter)) +
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
                    Perimeter = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter)) +
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
                    Perimeter = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter)) +
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
                    Perimeter = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter)) +
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
                    Perimeter = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter)) +
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
                    
                case .Star:
                    Perimeter = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter)) +
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
                    
                case .NGon:
                    Perimeter = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter)) +
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
                    Perimeter = self.PathLength
                    if Clockwise
                    {
                        Final = CGFloat(Int(self.AnimationOffset) % Int(Perimeter)) +
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
            self.NewTextOffset = Final
            self.UpdateOutput()
        }
    }
    
}
