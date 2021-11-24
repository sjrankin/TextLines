//
//  +ShapeGenerator.swift
//  +ShapeGenerator
//
//  Created by Stuart Rankin on 8/26/21.
//

import Foundation
import UIKit
import CoreGraphics
import Foundation

extension ViewController
{
    /// Create a path for the specified shape.
    /// - Parameter For: The shape to use to create a path.
    /// - Returns: A `UIBezierPath` of the specified path on success, nil on error.
    func MakePath(For Shape: Shapes) -> UIBezierPath?
    {
        HAdder = 0
        VAdder = 0
        var BezierPath: UIBezierPath? = nil
        #if true
        let ImageWidth = Settings.GetInt(.ViewportWidth)
        let ImageHeight = Settings.GetInt(.ViewportHeight)
        #else
        let ImageWidth = Settings.GetInt(.ImageWidth)
        let ImageHeight = Settings.GetInt(.ImageHeight)
        #endif
        
        switch Shape
        {
            case .Rectangle:
                var Width = Double(Settings.GetInt(.ViewportWidth))
                Width = Width * Double(Settings.GetDoubleNormal(.RectangleWidth))
                var Height = Double(Settings.GetInt(.ViewportHeight))
                Height = Height * Double(Settings.GetDoubleNormal(.RectangleHeight))
                let Top = (ImageHeight / 2) - (Int(Height) / 2)
                let Left = (ImageWidth / 2) - (Int(Width) / 2)
                let Radius = Settings.GetBool(.RectangleRoundedCorners) ? 20 : 0
                BezierPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 20 + Left, y: 20 + Top),
                                                              size: CGSize(width: Width - 40,
                                                                           height: Height - 40)),
                                          cornerRadius: CGFloat(Radius))
                
            case .Circle:
                let Diameter = Settings.GetInt(.CircleDiameter, IfZero: 500)
                let Top = (ImageHeight / 2) - (Diameter / 2)
                let Left = (ImageWidth / 2) - (Diameter / 2)
                BezierPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: 20 + Left, y: 20 + Top),
                                                         size: CGSize(width: Diameter - 40,
                                                                      height: Diameter - 40)))
                
            case .Ellipse:
                var Width = Double(Settings.GetInt(.ViewportWidth))
                Width = Width * Double(Settings.GetDoubleNormal(.EllipseMajor))
                var Height = Double(Settings.GetInt(.ViewportHeight))
                Height = Height * Double(Settings.GetDoubleNormal(.EllipseMinor))
                let Top = (ImageHeight / 2) - (Int(Height) / 2)
                let Left = (ImageWidth / 2) - (Int(Width) / 2)
                BezierPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: 20 + Left, y: 20 + Top),
                                                         size: CGSize(width: Width - 40,
                                                                      height: Height - 40)))
                
            case .Triangle:
                var Base = CGFloat(Settings.GetDoubleNormal(.TriangleBase))
                Base = Base * Double(Settings.GetInt(.ViewportWidth))
                var Height = CGFloat(Settings.GetDoubleNormal(.TriangleHeight))
                Height = Height * Double(Settings.GetInt(.ViewportHeight))
                #if true
                BezierPath = UIBezierPath()
                let CenterX = CGFloat(Settings.GetInt(.ViewportWidth) / 2)
                var HalfWidth = Base / 2.0
                let HorizontalOffset = (Double(Settings.GetInt(.ViewportWidth) / 2) - HalfWidth) / 2.0
                HalfWidth = HalfWidth + HorizontalOffset
                let CenterY = CGFloat(Settings.GetInt(.ViewportHeight) / 2)
                let Top = CenterY - (Height / 2.0)
                let Bottom = CenterY + Height / 2.0
                BezierPath?.move(to: CGPoint(x: CenterX, y: Bottom))
                BezierPath?.addLine(to: CGPoint(x: CenterX - HalfWidth, y: Bottom))
                BezierPath?.addLine(to: CGPoint(x: CenterX, y: Top))
                BezierPath?.addLine(to: CGPoint(x: CenterX + HalfWidth, y: Bottom))
                BezierPath?.addLine(to: CGPoint(x: HalfWidth, y: Bottom))
                #else
                if Settings.GetBool(.TriangleRounded)
                {
                    //https://stackoverflow.com/questions/20442203/uibezierpath-triangle-with-rounded-edges
                    let point1 = CGPoint(x: -Base / 2, y: Height / 2)
                    let point2 = CGPoint(x: 0, y: -Height / 2)
                    let point3 = CGPoint(x: Base / 2, y: Height / 2)
                    
                    let path = CGMutablePath()
                    path.move(to: CGPoint(x: 0, y: Height / 2))
                    path.addArc(tangent1End: point1, tangent2End: point2, radius: 10.0)
                    path.addArc(tangent1End: point2, tangent2End: point3, radius: 10.0)
                    path.addArc(tangent1End: point3, tangent2End: point1, radius: 10.0)
                    path.closeSubpath()
                    BezierPath = UIBezierPath(cgPath: path)
                    if BezierPath == nil
                    {
                        Debug.FatalError("BezierPath is nil")
                    }
                }
                else
                {
                    BezierPath = UIBezierPath()
                    let CenterX = CGFloat(Settings.GetInt(.ViewportWidth) / 2)
                    var HalfWidth = Base / 2.0
                    let HorizontalOffset = (Double(Settings.GetInt(.ViewportWidth) / 2) - HalfWidth) / 2.0
                    HalfWidth = HalfWidth + HorizontalOffset
                    let CenterY = CGFloat(Settings.GetInt(.ViewportHeight) / 2)
                    print("CenterX,CenterY=\(CenterX),\(CenterY)")
                    let Top = CenterY - (Height / 2.0)
                    let Bottom = CenterY + Height / 2.0
                    print("Top,Bottom=\(Top),\(Bottom)")
                    BezierPath?.move(to: CGPoint(x: HalfWidth, y: Bottom))
                    BezierPath?.addLine(to: CGPoint(x: CenterX - HalfWidth, y: Bottom))
                    BezierPath?.addLine(to: CGPoint(x: HalfWidth, y: Top))
                    BezierPath?.addLine(to: CGPoint(x: CenterX + HalfWidth, y: Bottom))
                    BezierPath?.addLine(to: CGPoint(x: HalfWidth, y: Bottom))
                }
                #endif
                
            case .Line:
                BezierPath = UIBezierPath()
                var Length = Settings.GetDoubleNormal(.LineLength)
                switch Settings.GetEnum(ForKey: .LineType, EnumType: LineOptions.self, Default: .Horizontal)
                {
                    case .Horizontal:
                        Length = Length * Double(Settings.GetInt(.ViewportWidth))
                        BezierPath?.move(to: CGPoint(x: 20, y: 20))
                        BezierPath?.addLine(to: CGPoint(x: Length, y: 20))
                        
                    case .Vertical:
                        Length = Length * Double(Settings.GetInt(.ViewportHeight))
                        BezierPath?.move(to: CGPoint(x: 20, y: 20))
                        BezierPath?.addLine(to: CGPoint(x: 20, y: Length))
                        
                    case .DiagonalDescending:
                        Length = Length * Double(Settings.GetInt(.ViewportWidth))
                        BezierPath?.move(to: CGPoint(x: 20, y: 20))
                        let Theta = 45.0.Radians
                        let X = Double(Length) * cos(Theta)
                        let Y = Double(Length) * sin(Theta)
                        BezierPath?.move(to: CGPoint(x: X, y: Y))
                        
                    case .DiagonalAscending:
                        Length = Length * Double(Settings.GetInt(.ViewportWidth))
                        BezierPath?.move(to: CGPoint(x: 20, y: Length))
                        let Theta = -45.0.Radians
                        let X = Double(Length) * cos(Theta)
                        let Y = Double(Length) * sin(Theta)
                        BezierPath?.move(to: CGPoint(x: X, y: Y))
                }

            case .Scribble:
                return nil
                
            case .Infinity:
                BezierPath = UIBezierPath.CreateInfinityPath(LeftCenter: CGPoint(x: 330, y: 350),
                                                             RightCenter: CGPoint(x: 700, y: 350),
                                                             Radius: 260.0,
                                                             Width: 1.0)
                
            case .Spiral:
                let center = CGPoint(x: ImageWidth / 2, y: ImageHeight / 2)
                let startRad: CGFloat = Settings.GetCGFloat(.SpiralStartRadius)
                let space: CGFloat = Settings.GetCGFloat(.SpiralSpacePerLoop)
                let starttheta: CGFloat = Settings.GetCGFloat(.SpiralStartTheta)
                let endtheta: CGFloat = Settings.GetCGFloat(.SpiralEndTheta)
                let thetastep: CGFloat = Settings.GetCGFloat(.SpiralThetaStep, 1.0)
                BezierPath = UIBezierPath.CreateSpiralPath(Center: center,
                                                           StartRadius: startRad,
                                                           LoopGap: space,
                                                           StartTheta: starttheta,
                                                           EndTheta: endtheta,
                                                           ThetaStep: thetastep)
                
            case .Hexagon:
                BezierPath = UIBezierPath()
                let CenterX = Settings.GetIntAsDouble(.ViewportWidth) / 2.0
                let CenterY = Settings.GetIntAsDouble(.ViewportHeight) / 2.0
                var Radius = min(CenterX, CenterY)
                let HexWidth = Settings.GetDoubleNormal(.HexagonWidth)
                let HexHeight = Settings.GetDoubleNormal(.HexagonHeight)
                let MinDistance = min(HexWidth, HexHeight)
                Radius = Radius * MinDistance
                let RadialOffset = 90.0

                let StartX = Radius * cos((-30.0 + RadialOffset).Radians) + CenterX
                let StartY = Radius * sin((-30.0 + RadialOffset).Radians) + CenterY
                BezierPath?.move(to: CGPoint(x: StartX, y: StartY))
                for Angle in stride(from: (30.0 + RadialOffset), through: (330.0 + RadialOffset), by: 60.0)
                {
                    let Radians = Angle.Radians
                    let X = Radius * cos(Radians) + CenterX
                    let Y = Radius * sin(Radians) + CenterY
                    BezierPath?.addLine(to: CGPoint(x: X, y: Y))
                }
                
            case .Octagon:
                BezierPath = UIBezierPath()
                let CenterX = Settings.GetIntAsDouble(.ViewportWidth) / 2.0
                let CenterY = Settings.GetIntAsDouble(.ViewportHeight) / 2.0
                var Radius = min(CenterX, CenterY)
                let HexWidth = Settings.GetDoubleNormal(.HexagonWidth)
                let HexHeight = Settings.GetDoubleNormal(.HexagonHeight)
                let MinDistance = min(HexWidth, HexHeight)
                Radius = Radius * MinDistance
                let RadialOffset = 90.0
                
                let RadialIncrement = 360.0 / 8.0
                let StartX = Radius * cos((RadialOffset).Radians) + CenterX
                let StartY = Radius * sin((RadialOffset).Radians) + CenterY
                BezierPath?.move(to: CGPoint(x: StartX, y: StartY))
                for Angle in stride(from: (RadialOffset), through: (360.0 + RadialOffset), by: RadialIncrement)
                {
                    let Radians = Angle.Radians
                    let X = Radius * cos(Radians) + CenterX
                    let Y = Radius * sin(Radians) + CenterY
                    BezierPath?.addLine(to: CGPoint(x: X, y: Y))
                }
                
            case .Heart:
                //https://stackoverflow.com/questions/29227858/how-to-draw-heart-shape-in-uiview-ios
                BezierPath = UIBezierPath()
                let XOffset = 10
                let YOffset = 10
                let originalRect = CGRect(origin: CGPoint(x: 0, y: 0),
                                          size: CGSize(width: 1000, height: 1000))
                let scale = 1.0
                let scaledWidth = (originalRect.size.width * CGFloat(scale))
                let scaledXValue = ((originalRect.size.width) - scaledWidth) / 2
                let scaledHeight = (originalRect.size.height * CGFloat(scale))
                let scaledYValue = ((originalRect.size.height) - scaledHeight) / 2
                
                let scaledRect = CGRect(x: scaledXValue,
                                        y: scaledYValue,
                                        width: scaledWidth,
                                        height: scaledHeight)
                
                BezierPath?.move(to: CGPoint(x: originalRect.size.width/2,
                                             y: scaledRect.origin.y + scaledRect.size.height))
                
                
                BezierPath?.addCurve(to: CGPoint(x: scaledRect.origin.x,
                                                 y: scaledRect.origin.y + (scaledRect.size.height/4)),
                                     controlPoint1:CGPoint(x: scaledRect.origin.x + (scaledRect.size.width/2),
                                                           y: scaledRect.origin.y + (scaledRect.size.height*3/4)) ,
                                     controlPoint2: CGPoint(x: scaledRect.origin.x,
                                                            y: scaledRect.origin.y + (scaledRect.size.height/2)) )
                
                BezierPath?.addArc(withCenter: CGPoint( x: scaledRect.origin.x + (scaledRect.size.width/4),
                                                        y: scaledRect.origin.y + (scaledRect.size.height/4)),
                                   radius: (scaledRect.size.width/4),
                                   startAngle: CGFloat(Double.pi),
                                   endAngle: 0,
                                   clockwise: true)
                
                BezierPath?.addArc(withCenter: CGPoint( x: scaledRect.origin.x + (scaledRect.size.width * 3/4),
                                                        y: scaledRect.origin.y + (scaledRect.size.height/4)),
                                   radius: (scaledRect.size.width/4),
                                   startAngle: CGFloat(Double.pi),
                                   endAngle: 0,
                                   clockwise: true)
                
                BezierPath?.addCurve(to: CGPoint(x: originalRect.size.width/2,
                                                 y: scaledRect.origin.y + scaledRect.size.height),
                                     controlPoint1: CGPoint(x: scaledRect.origin.x + scaledRect.size.width,
                                                            y: scaledRect.origin.y + (scaledRect.size.height/2)),
                                     controlPoint2: CGPoint(x: scaledRect.origin.x + (scaledRect.size.width/2),
                                                            y: scaledRect.origin.y + (scaledRect.size.height*3/4)) )
                
                let Translation = CGAffineTransform(translationX: CGFloat(XOffset), y: CGFloat(YOffset))
                BezierPath?.apply(Translation)
                
            case .User:
                if UserShapeManager.Count == 0
                {
                    return BezierPath
                }
                if let CurrentID = Settings.GetNillableUUID(.CurrentUserShape)
                {
                    if let UserShape = UserShapeManager.GetShape(With: CurrentID)
                    {
                        BezierPath = UserShape.Path()
                    }
                }
        }
        
        return BezierPath
    }
    
    /// Plot the passed text on the passed `UIBezierPath`.
    /// - Note: Visual attributes are retrieved from user settings.
    /// - Parameter Text: The string to plot.
    /// - Parameter On: The path on which the text will be plotted.
    /// - Parameter With: Starting offset for the text. Can be used to simulate animated
    ///                   text traversal down the path (or up the path, depending on the
    ///                   sign of the value).
    /// - Returns: Image containing the plotted text. Nil on error.
    func PlotText(_ Text: String, On Path: UIBezierPath,
                  With Offset: CGFloat) -> UIImage?
    {
        PathLength = Path.length
        
        var FinalText = Text
        let RotateChars = Settings.GetBool(.RotateCharacters)
        if RotateChars
        {
            let ReversedText = Text.reversed()
            FinalText = String(ReversedText)
        }
        
        let attributedString = NSAttributedString(
            string: FinalText,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.black),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ])
        
        var bezier = Bezier(path: Path.cgPath)
        bezier.Original = Path
        bezier.ShowPath = true
#if true
        let ImageWidth = Settings.GetInt(.ViewportWidth)
        let ImageHeight = Settings.GetInt(.ViewportHeight)
        #else
        let ImageWidth = Settings.GetInt(.ImageWidth)
        let ImageHeight = Settings.GetInt(.ImageHeight)
        #endif
        let ImageSize = CGSize(width: ImageWidth, height: ImageHeight)
        print("*** ImageSize=\(ImageSize)")
        
        // generate an image
        let image = bezier.TextOnPath(withAttributed: attributedString,
                                      size: ImageSize,
                                      align: .center,
                                      StartOffset: Offset,
                                      RotateChars: RotateChars,
                                      VerticalAdder: VAdder,
                                      HorizontalAdder: HAdder,
                                      GlobalCharPositions: &CharLocations)
        //for Index in 0 ..< CharLocations.count
        //{
        //    print("Char[\(Index)]=\(CharLocations[Index])")
        //}
        return image
    }
}
