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
        let ImageWidth = Settings.GetInt(.ImageWidth)
        let ImageHeight = Settings.GetInt(.ImageHeight)
        
        switch Shape
        {
            case .Rectangle:
                let RWidth = Settings.GetInt(.RectangleWidth, IfZero: 400)
                let RHeight = Settings.GetInt(.RectangleHeight, IfZero: 400)
                print("RWidth=\(RWidth), RHeight=\(RHeight)")
                let Radius = Settings.GetBool(.RectangleRoundedCorners) ? 20 : 0
                BezierPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 20, y: 20),
                                                              size: CGSize(width: RWidth - 40,
                                                                           height: RHeight - 40)),
                                          cornerRadius: CGFloat(Radius))
                
            case .Circle:
                let Diameter = Settings.GetInt(.CircleDiameter, IfZero: 500)
                let Top = (ImageHeight / 2) - (Diameter / 2)
                let Left = (ImageWidth / 2) - (Diameter / 2)
                BezierPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: 20 + Left, y: 20 + Top),
                                                         size: CGSize(width: Diameter - 40,
                                                                      height: Diameter - 40)))
                
            case .Ellipse:
//                let Width = Settings.GetInt(.EllipseMajor, IfZero: 500)
//                let Height = Settings.GetInt(.EllipseMinor, IfZero: 300)
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
                VAdder = 50
                HAdder = 50
                let Base = CGFloat(Settings.GetInt(.TriangleBase, IfZero: 500))
                let Height = CGFloat(Settings.GetInt(.TriangleHeight, IfZero: 500))
                print("Base=\(Base), Height=\(Height)")
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
                    let HOffset: CGFloat = 20
                    let VOffset: CGFloat = 20
                    BezierPath?.move(to: CGPoint(x: (Base / 2), y: 0 + VOffset))
                    BezierPath?.addLine(to: CGPoint(x: Base - HOffset, y: Height - VOffset))
                    BezierPath?.addLine(to: CGPoint(x: 0 + HOffset, y: Height - VOffset))
                    BezierPath?.addLine(to: CGPoint(x: (Base / 2), y: 0 + VOffset))
                }
                
            case .Line:
                BezierPath = UIBezierPath()
                let Length = Settings.GetInt(.LineLength, IfZero: 500)
                switch Settings.GetEnum(ForKey: .LineType, EnumType: LineOptions.self, Default: .Horizontal)
                {
                    case .Horizontal:
                        BezierPath?.move(to: CGPoint(x: 20, y: 20))
                        BezierPath?.addLine(to: CGPoint(x: Length, y: 20))
                        
                    case .Vertical:
                        BezierPath?.move(to: CGPoint(x: 20, y: 20))
                        BezierPath?.addLine(to: CGPoint(x: 20, y: Length))
                        
                    case .DiagonalDescending:
                        BezierPath?.move(to: CGPoint(x: 20, y: 20))
                        let Theta = 45.0.Radians
                        let X = Double(Length) * cos(Theta)
                        let Y = Double(Length) * sin(Theta)
                        BezierPath?.move(to: CGPoint(x: X, y: Y))
                        
                    case .DiagonalAscending:
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
                let a = 240.0
                let RawX = a / 2.0
                let RawY = (sqrt(3.0) * a) / 2.0
                var A = CGPoint(x: a, y: 0)
                var B = CGPoint(x: RawX, y: RawY)
                var C = CGPoint(x: -RawX, y: RawY)
                var D = CGPoint(x: -a, y: 0)
                var E = CGPoint(x: -RawX, y: -RawY)
                var F = CGPoint(x: RawX, y: -RawY)
                A = CGPoint.Add(A, X: 250, Y: 250)
                B = CGPoint.Add(B, X: 250, Y: 250)
                C = CGPoint.Add(C, X: 250, Y: 250)
                D = CGPoint.Add(D, X: 250, Y: 250)
                E = CGPoint.Add(E, X: 250, Y: 250)
                F = CGPoint.Add(F, X: 250, Y: 250)
                BezierPath?.move(to: A)
                BezierPath?.addLine(to: B)
                BezierPath?.addLine(to: C)
                BezierPath?.addLine(to: D)
                BezierPath?.addLine(to: E)
                BezierPath?.addLine(to: F)
                BezierPath?.addLine(to: A)
                
            case .Octagon:
                //https://math.stackexchange.com/questions/925677/can-anyone-give-me-x-y-coordinates-for-an-octagon
                BezierPath = UIBezierPath()
                let Sq22: CGFloat = sqrt(2.0) / 2.0
                var A = CGPoint(x: 1, y: 0)
                var B = CGPoint(x: Sq22, y: Sq22)
                var C = CGPoint(x: 0, y: 1)
                var D = CGPoint(x: -Sq22, y: Sq22)
                var E = CGPoint(x: -1, y: 0)
                var F = CGPoint(x: -Sq22, y: -Sq22)
                var G = CGPoint(x: 0, y: -1)
                var H = CGPoint(x: Sq22, y: -Sq22)
                A = CGPoint.Multiply(A, X: 240, Y: 240)
                B = CGPoint.Multiply(B, X: 240, Y: 240)
                C = CGPoint.Multiply(C, X: 240, Y: 240)
                D = CGPoint.Multiply(D, X: 240, Y: 240)
                E = CGPoint.Multiply(E, X: 240, Y: 240)
                F = CGPoint.Multiply(F, X: 240, Y: 240)
                G = CGPoint.Multiply(G, X: 240, Y: 240)
                H = CGPoint.Multiply(H, X: 240, Y: 240)
                A = CGPoint.Add(A, X: 250, Y: 250)
                B = CGPoint.Add(B, X: 250, Y: 250)
                C = CGPoint.Add(C, X: 250, Y: 250)
                D = CGPoint.Add(D, X: 250, Y: 250)
                E = CGPoint.Add(E, X: 250, Y: 250)
                F = CGPoint.Add(F, X: 250, Y: 250)
                G = CGPoint.Add(G, X: 250, Y: 250)
                H = CGPoint.Add(H, X: 250, Y: 250)
                BezierPath?.move(to: A)
                BezierPath?.addLine(to: B)
                BezierPath?.addLine(to: C)
                BezierPath?.addLine(to: D)
                BezierPath?.addLine(to: E)
                BezierPath?.addLine(to: F)
                BezierPath?.addLine(to: G)
                BezierPath?.addLine(to: H)
                BezierPath?.addLine(to: A)
                
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
        let ImageWidth = Settings.GetInt(.ImageWidth)
        let ImageHeight = Settings.GetInt(.ImageHeight)
        let ImageSize = CGSize(width: ImageWidth, height: ImageHeight)
        
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
