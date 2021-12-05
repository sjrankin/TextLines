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
                let Width = Settings.GetIntAsDouble(.ViewportWidth)
                let Height = Settings.GetIntAsDouble(.ViewportHeight)
                let HalfWidth = Width / 2.0
                let HalfHeight = Height / 2.0
                switch Settings.GetEnum(ForKey: .LineType, EnumType: LineOptions.self, Default: .Horizontal)
                {
                    case .Horizontal:
                        Length = Length * Width
                        let HalfLength = Length / 2.0
                        let XStart = HalfWidth - HalfLength
                        BezierPath?.move(to: CGPoint(x: XStart, y: HalfHeight))
                        BezierPath?.addLine(to: CGPoint(x: Width - XStart, y: HalfHeight))
                        
                    case .Vertical:
                        Length = Length * Width
                        let HalfLength = Length / 2.0
                        let YStart = HalfHeight - HalfLength
                        BezierPath?.move(to: CGPoint(x: HalfWidth, y: YStart))
                        BezierPath?.addLine(to: CGPoint(x: HalfWidth, y: Height - YStart))
                        
                    case .DiagonalDescending:
                        let MinDimension = min(Width, Height)
                        Length = Length * MinDimension
                        let HalfLength = Length / 2.0
                        let ULAngle = (315.0 - 90.0).Radians
                        let LRAngle = (135.0 - 90.0).Radians
                        let ULX = HalfLength * cos(ULAngle) + HalfWidth
                        let ULY = HalfLength * sin(ULAngle) + HalfHeight
                        let LRX = HalfLength * cos(LRAngle) + HalfWidth
                        let LRY = HalfLength * sin(LRAngle) + HalfHeight
                        BezierPath?.move(to: CGPoint(x: ULX, y: ULY))
                        BezierPath?.addLine(to: CGPoint(x: LRX, y: LRY))
                        
                    case .DiagonalAscending:
                        let MinDimension = min(Width, Height)
                        Length = Length * MinDimension
                        let HalfLength = Length / 2.0
                        let URAngle = (45.0 - 90.0).Radians
                        let LLAngle = (225.0 - 90.0).Radians
                        let ULX = HalfLength * cos(URAngle) + HalfWidth
                        let ULY = HalfLength * sin(URAngle) + HalfHeight
                        let LRX = HalfLength * cos(LLAngle) + HalfWidth
                        let LRY = HalfLength * sin(LLAngle) + HalfHeight
                        BezierPath?.move(to: CGPoint(x: ULX, y: ULY))
                        BezierPath?.addLine(to: CGPoint(x: LRX, y: LRY))
                }

            case .Scribble:
                return nil
                
            case .Star:
                let VertexCount = Settings.GetInt(.StarVertexCount)
                if VertexCount < 3
                {
                    return nil
                }
                let Min = CGFloat(min(ImageWidth / 2, ImageHeight / 2))
                let OuterNormal = Settings.GetDoubleNormal(.StarOuterRadius)
                let InnerNormal = Settings.GetDoubleNormal(.StarInnerRadius)
                let OuterRadius = Min * CGFloat(OuterNormal)
                let InnerRadius = Min * CGFloat(InnerNormal)

                let CenterX = CGFloat(ImageWidth) / 2.0
                let CenterY = CGFloat(ImageHeight) / 2.0
                let StarCenter = CGPoint(x: CenterX, y: CenterY)
                let AllVertices = VertexCount * 2
                var Points = [CGPoint]()
                let Rotation = Settings.GetDouble(.StarRotation)
                let AngleIncrement = 360.0 / Double(AllVertices)
                for Index in 0 ..< AllVertices
                {
                    if Index.isMultiple(of: 2)
                    {
                        //Outer radius
                        let VertexPoint = PolarToCartesian(Degrees: CGFloat(Index) * AngleIncrement + CGFloat(Rotation),
                                                           Radius: OuterRadius,
                                                           Center: StarCenter)
                        Points.append(VertexPoint)
                    }
                    else
                    {
                        //Inner radius
                        let VertexPoint = PolarToCartesian(Degrees: CGFloat(Index) * AngleIncrement + CGFloat(Rotation),
                                                           Radius: InnerRadius,
                                                           Center: StarCenter)
                        Points.append(VertexPoint)
                    }
                }
                if Settings.GetBool(.StarDrawSmooth)
                {
                    let Smoothed = Chaikin.SmoothPoints(Points: Points, Iterations: 4, Closed: true)
                    Points = Smoothed
                }
                BezierPath = UIBezierPath()
                BezierPath?.move(to: Points[0])
                for Index in 1 ..< Points.count
                {
                    BezierPath?.addLine(to: Points[Index])
                }
                BezierPath?.addLine(to: Points[0])
                
            case .NGon:
                let Vertices = Settings.GetInt(.NGonVertexCount)
                if Vertices < 3
                {
                    return nil
                }
                let CenterY = CGFloat(ImageHeight) / 2.0
                let CenterX = CGFloat(ImageWidth) / 2.0
                let Center = CGPoint(x: CenterX, y: CenterY)
                var Min = CGFloat(min(ImageWidth / 2, ImageHeight / 2))
                Min = Min - (Min * 0.05)
                var Points = [CGPoint]()
                let AngleIncrement = 360.0 / CGFloat(Vertices)
                let NGonRotation = Settings.GetDouble(.NGonRotation)
                for Index in 0 ..< Vertices
                {
                    let VertexPoint = PolarToCartesian(Degrees: CGFloat(Index) * AngleIncrement + CGFloat(NGonRotation),
                                                       Radius: CGFloat(Min),
                                                       Center: Center)
                    Points.append(VertexPoint)
                }
                if Settings.GetBool(.NGonDrawSmooth)
                {
                    let Smoothed = Chaikin.SmoothPoints(Points: Points,
                                                        Iterations: 4,
                                                        Closed: true)
                    Points = Smoothed
                }
                BezierPath = UIBezierPath()
                BezierPath?.move(to: Points[0])
                for Index in 1 ..< Points.count
                {
                    BezierPath?.addLine(to: Points[Index])
                }
                BezierPath?.addLine(to: Points[0])
                
            case .Infinity:
                let CenterY = CGFloat(ImageHeight) / 2.0
                let LeftX = CGFloat(ImageWidth) / 3.0
                let RightX = CGFloat(ImageWidth) - LeftX
                BezierPath = UIBezierPath.CreateInfinityPath(LeftCenter: CGPoint(x: LeftX, y: CenterY),
                                                             RightCenter: CGPoint(x: RightX, y: CenterY),
                                                             Radius: 260.0,
                                                             Width: 1.0)
                
            case .Spiral:
                let SpiralCenter = CGPoint(x: ImageWidth / 2, y: ImageHeight / 2)
                let StartRadius: CGFloat = Settings.GetCGFloat(.SpiralStartRadius)
                let LineGap: CGFloat = Settings.GetCGFloat(.SpiralSpacePerLoop)
                let StartAngle: CGFloat = Settings.GetCGFloat(.SpiralStartTheta)
                let EndAngle: CGFloat = Settings.GetCGFloat(.SpiralEndTheta)
                let CurveEccentricity: CGFloat = Settings.GetCGFloat(.SpiralThetaStep, 1.0)
                let IsSquare = Settings.GetBool(.SpiralSquare)
                BezierPath = UIBezierPath.CreateSpiralPath(Center: SpiralCenter,
                                                           StartRadius: StartRadius,
                                                           LoopGap: LineGap,
                                                           StartTheta: StartAngle,
                                                           EndTheta: EndAngle,
                                                           ThetaStep: CurveEccentricity,
                                                           Square: IsSquare) 
                
            case .Hexagon:
                BezierPath = UIBezierPath()
                let CenterX = Settings.GetIntAsDouble(.ViewportWidth) / 2.0
                let CenterY = Settings.GetIntAsDouble(.ViewportHeight) / 2.0
                var Radius = min(CenterX, CenterY)
                let HexWidth = Settings.GetDoubleNormal(.HexagonWidth)
                let HexHeight = Settings.GetDoubleNormal(.HexagonHeight)
                let MinDistance = min(HexWidth, HexHeight)
                Radius = Radius * MinDistance
                let RadialOffset = -90.0

                let StartX = Radius * cos(RadialOffset.Radians) + CenterX
                let StartY = Radius * sin(RadialOffset.Radians) + CenterY
                BezierPath?.move(to: CGPoint(x: StartX, y: StartY))
                for Angle in stride(from: RadialOffset,
                                    through: 360.0 + RadialOffset,
                                    by: 60.0)
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
        
        #if false
        if let PointSet = BezierPath?.cgPath.Points()
        {
            let TextFont = UIFont.systemFont(ofSize: 48.0)
            var Index = 1
            for SomePoint in PointSet
            {
                let Number = "\(Index)".Path(withFont: TextFont)
                let NumberPath = UIBezierPath(cgPath: Number)
                NumberPath.apply(CGAffineTransform(scaleX: 1.0, y: -1.0))
                let Move = CGAffineTransform(translationX: SomePoint.x + 32.0,
                                             y: SomePoint.y + 16.0)
                NumberPath.apply(Move)
                BezierPath?.append(NumberPath)
                
                Index = Index + 1
            }
        }
        #endif
        
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
        let ImageWidth = Settings.GetInt(.ViewportWidth)
        let ImageHeight = Settings.GetInt(.ViewportHeight)
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
    
    /// Convert passed polar coordinates to cartesian coordinates.
    /// - Parameter Degrees: Polar angle in degrees.
    /// - Parameter Radius: Polar coordinate's radial value.
    /// - Parameter Center: Center of the polar coordinate.
    /// - Returns: Cartesian equivalent of the passed polar coordinate.
    func PolarToCartesian(Degrees: CGFloat, Radius: CGFloat, Center: CGPoint) -> CGPoint
    {
        let X = Center.x + (Radius * cos(Degrees.Radians))
        let Y = Center.y - (Radius * sin(Degrees.Radians))
        return CGPoint(x: X, y: Y)
    }
}
