//
//  BezierString.swift
//
//  Created by Luka on 23. 11. 14.
//  Copyright (c) 2014 lvnyk
//
//  Modified by Stuart Rankin, August 2021.
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
//
//  The code in this file draws passed text along the path of a passed bezier shape.

import UIKit

// MARK: Rendering

/// Text rendering extension
extension Bezier
{
    /// Get the length of the path.
    var PathLength: CGFloat
    {
        get
        {
            return self.length()
        }
    }
    
    /// Plot debug points on the passed context for debugging purporses.
    /// - Parameter Context: The context where drawing will take place.
    /// - Parameter StringWidth: The width of the string that will be drawn.
    /// - Parameter PathLength: The total length of the path.
    func PlotDebugPoints(Context: CGContext, StringWidth: Int, PathLength: Int)
    {
        let ColorPoints =
        [
            UIColor.cyan.cgColor,
            UIColor.red.withAlphaComponent(0.5).cgColor,
            UIColor.magenta.cgColor,
            UIColor.green.withAlphaComponent(0.5).cgColor,
            UIColor.yellow.cgColor,
            UIColor.blue.withAlphaComponent(0.5).cgColor,
            UIColor.BlackGray.cgColor,
            UIColor.brown.withAlphaComponent(0.5).cgColor
        ]
        for DistanceIndex in 0 ..< 8
        {
            let Percent = CGFloat(DistanceIndex) / 8.0
            if let Start = self.path.point(at: Percent)
            {
                Context.beginPath()
                let CircleD = 20.0
                Context.setStrokeColor(UIColor.black.cgColor)
                Context.setFillColor(ColorPoints[DistanceIndex])
                Context.setLineWidth(1.0)
                let CRect = CGRect(x: Start.x - 10, y: Start.y - 10,
                                   width: CircleD, height: CircleD)
                Context.addEllipse(in: CRect)
                Context.drawPath(using: .fillStroke)
            }
        }
    }
    
    func PlotGridlines(Context: CGContext, ImageSize: CGSize)
    {
        let LineColor = Settings.GetColor(.GridColor, UIColor.systemYellow).cgColor
        Context.beginPath()
        Context.setStrokeColor(LineColor)
        Context.setLineWidth(1.0)
        
        for Y in stride(from: 0.0, through: ImageSize.height, by: 32.0)
        {
            Context.move(to: CGPoint(x: 0.0, y: Y))
            Context.addLine(to: CGPoint(x: ImageSize.width, y: Y))
        }
        for X in stride(from: 0.0, through: ImageSize.width, by: 32.0)
        {
            Context.move(to: CGPoint(x: X, y: 0.0))
            Context.addLine(to: CGPoint(x: X, y: ImageSize.height))
        }
        
        Context.drawPath(using: .stroke)
    }
    
    /// Plot testing/guidemarks on the passed context for debug purposes.
    /// - Parameter Context: The context on which drawing will be done.
    /// - Parameter ImageSize: The size of the context.
    func PlotGuideMarks(Context: CGContext, ImageSize: CGSize)
    {
        let CenterX = ImageSize.width / 2
        let CenterY = ImageSize.height / 2
        
        Context.beginPath()
        Context.setStrokeColor(UIColor.magenta.cgColor)
        Context.setLineWidth(1.0)
        Context.move(to: CGPoint(x: CenterX, y: 0))
        Context.addLine(to: CGPoint(x: CenterX, y: ImageSize.height))
        Context.move(to: CGPoint(x: 0, y: CenterY))
        Context.addLine(to: CGPoint(x: ImageSize.width, y: CenterY))
        Context.drawPath(using: .fillStroke)
        
        Context.beginPath()
        Context.setLineDash(phase: 0, lengths: [2, 2])
        Context.move(to: CGPoint(x: 0, y: 0))
        Context.addLine(to: CGPoint(x: ImageSize.width, y: ImageSize.height))
        Context.move(to: CGPoint(x: 0, y: ImageSize.height))
        Context.addLine(to: CGPoint(x: ImageSize.width, y: 0))
        Context.drawPath(using: .fillStroke)
        
        Context.beginPath()
        Context.setStrokeColor(UIColor.yellow.cgColor)
        Context.setLineDash(phase: 0, lengths: [3, 3])
        Context.move(to: CGPoint(x: 20, y: 20))
        Context.addLine(to: CGPoint(x: ImageSize.width - 20, y: 20))
        Context.addLine(to: CGPoint(x: ImageSize.width - 20, y: ImageSize.height - 20))
        Context.addLine(to: CGPoint(x: 20, y: ImageSize.height - 20))
        Context.addLine(to: CGPoint(x: 20, y: 20))
        Context.drawPath(using: .stroke)
    }
    
    /// Adds the string to the provided context, following the instance bezier path.
    /// - Notes:
    ///   - If animation is enabled, `StartOffset` is ignored.
    ///   - If the value of `PhraseAlignment` is **not** `.None`, `StartOffset` is ignored.
    /// - Parameters:
    ///   - string: The string to draw on the context.
    ///   - context: The context in which to draw.
    ///   - alignment: Text alignment. Default is `.Center`.
    ///   - y: The vertical offset relative to the centerline in units of light height. Defaults to `0`.
    ///   - offset: Offset value to plot the text. Used with animation.
    ///   - fitWidth: Determines if the text is fitted to the width of the bezier path.
    ///   - StartOffset: Starting offset of the string.
    ///   - RotateChars: Determines if the characters are rotated 180° from the tanget of the
    ///                  bezier path.
    ///   - Size: Size of the image.
    ///   - PhraseAlignment: Determines how to align the text on the shape. If this value is `.None`,
    ///                      `StartOffset` is used to determine where to place the text.
    ///   - GlobalCharPositions: Locations of all of the characters plotted.
    func DrawTextOnPath(attributed string: NSAttributedString,
                        to context: CGContext,
                        align alignment: NSTextAlignment = .center,
                        y offset: CGFloat = 0,
                        fitWidth: Bool = false,
                        StartOffset: CGFloat = 0.0,
                        RotateChars: Bool,
                        Size: CGSize,
                        PhraseAlignment: ShapeAlignments,
                        GlobalCharPositions: inout [CGPoint])
    {
        let pathLength = PathLength
        print("PathLength=\(pathLength)")
        
        context.saveGState()
        
        context.setAllowsFontSmoothing(true)
        context.setShouldSmoothFonts(true)
        
        context.setAllowsFontSubpixelPositioning(true)
        context.setShouldSubpixelPositionFonts(true)
        
        context.setAllowsFontSubpixelQuantization(true)
        context.setShouldSubpixelQuantizeFonts(true)
        
        context.setAllowsAntialiasing(true)
        context.setShouldAntialias(true)
        
        context.interpolationQuality = CGInterpolationQuality.high
        
        let line = CTLineCreateWithAttributedString(string)
        let runs = CTLineGetGlyphRuns(line)
        
        var linePos: CGFloat = 0
        let charSpacing: CGFloat
        let align: NSTextAlignment
        
        var Ascent: CGFloat = 0
        var Descent: CGFloat = 0
        var Leading: CGFloat = 0
        let stringWidth = CGFloat(CTLineGetTypographicBounds(line,
                                                             &Ascent,
                                                             &Descent,
                                                             &Leading))
        let height = Ascent - (Descent * 2) + (Leading * 2)
        
        let scale: CGFloat
        let spaceRemaining: CGFloat
        if fitWidth && (pathLength < stringWidth)
        {
            spaceRemaining = 0
            scale = min(1, pathLength / stringWidth)
        }
        else
        {
            spaceRemaining = pathLength - stringWidth
            scale = 1
        }
        
        if spaceRemaining < 0
        {
            align = .justified
        }
        else
        {
            align = alignment
        }
        
        let BGColor = Settings.GetColor(.BackgroundColor, UIColor.white)
        BGColor.setFill()
        context.fill(CGRect(origin: CGPoint.zero, size: Size))
        if Settings.GetBool(.ShowGuidelines)
        {
            let MainPath = self.Original
            MainPath.lineWidth = Settings.GetCGFloat(.GuidelineWidth, 2.0)
            Settings.GetColor(.GuidelineColor, UIColor.red).setStroke()
            MainPath.stroke()
        }
        
        //The index in the shape where to center the text initially.
        let CenteringIndices: [Shapes: Int] =
        [
            .Circle: 6,
            .Ellipse: 6,
            .Rectangle: 1,
            .Triangle: 4,
            .Hexagon: 0,
            .Octagon: 4,
            .Line: 3,
            .Spiral: 7,
            .Scribble: 0,
            .Heart: 1,
            .Infinity: 1,
            .User: 1,
        ]
        let CurrentShape = Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
        var CenterIndex = CenteringIndices[CurrentShape] ?? 0
        
        switch PhraseAlignment
        {
            case .None:
                //No alignment.
                break
                
            case .Top:
                //Already done.
                break
                
            case .Bottom:
                CenterIndex = 8 - CenterIndex
                
            case .Left:
                CenterIndex = abs((CenterIndex - 2) % 8)
                
            case .Right:
                CenterIndex = (CenterIndex + 2) % 8
        }
        let TextCenter = (CGFloat(CenterIndex) / 8) * pathLength
        let HalfString = stringWidth / 2
        var TextStart = TextCenter - HalfString
        if TextStart < 0
        {
            TextStart = pathLength + TextStart
        }

        #if false
        TextStart = StartOffset
        print("StartOffset=\(StartOffset)")
        #else
        if Settings.GetBool(.Animating)
        {
            TextStart = StartOffset
        }
        #endif
        
        switch align
        {
            case .center:
                linePos = spaceRemaining / 2
                #if false
                linePos += TextStart
                #else
                if Settings.GetBool(.Animating)
                {
                    linePos += TextStart
                }
                else
                {
                    linePos = TextStart
                }
                #endif
                charSpacing = 0
                
            case .right:
                linePos = spaceRemaining
                charSpacing = 0
                
            case .justified:
                charSpacing = spaceRemaining / CGFloat(max(2, string.length - 1))
                if string.length == 1
                {
                    linePos = charSpacing
                }
                
            default:
                charSpacing = 0
        }
        
        var glyphOffset: CGFloat = 0
        
        for r in 0 ..< CFArrayGetCount(runs)
        {
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runs, r), to: CTRun.self)
            let runCount = CTRunGetGlyphCount(run)
            
            let kern = (CTRunGetAttributes(run) as? [String: Any])? [NSAttributedString.Key.kern.rawValue] as? CGFloat ?? 0
            
            var advances = Array(repeating: CGSize.zero, count: runCount)
            CTRunGetAdvances(run, CFRange(location: 0, length: runCount), &advances)
            
            var cwidth = 0.0
            var clength = 0.0
            for (_, advance) in advances.enumerated()
            {
                let width = advance.width - kern
                cwidth += width - kern
                clength += linePos + width / 2
            }
            
            for (i, advance) in advances.enumerated()
            {
                let width = advance.width - kern
                var length = linePos + width / 2
                if length > PathLength
                {
                    length = length - PathLength
                }
                
                guard let p = self.properties(at: length) else
                {
                    Debug.Print("No property found at \(length)")
                    break
                }
                
                let CharAngle = RotateChars ? p.normal - CGFloat.pi : p.normal
                GlobalCharPositions.append(p.position)
                
                let textTransform = CGAffineTransform(scaleX: 1, y: -1)
                    .concatenating(CGAffineTransform(translationX: -glyphOffset - width / 2 / scale,
                                                     y: height * (0.5 + offset))
                                    .concatenating(CGAffineTransform(scaleX: scale, y: scale)
                                                    .concatenating(CGAffineTransform(rotationAngle: CharAngle)
                                                                    .concatenating(CGAffineTransform(translationX: p.position.x, y: p.position.y)))))
                
                context.textMatrix = textTransform
                CTRunDraw(run, context, CFRange(location: i, length: 1))
                glyphOffset += width + kern
                linePos += (charSpacing + width + kern) * scale
            }
        }
        
        if Settings.GetBool(.ShowGuideMarks)
        {
            PlotGuideMarks(Context: context, ImageSize: Size)
            PlotDebugPoints(Context: context,
                            StringWidth: Int(stringWidth),
                            PathLength: Int(pathLength))
        }
        if Settings.GetBool(.ShowGridLines)
        {
            PlotGridlines(Context: context, ImageSize: Size)
        }
        
        context.restoreGState()
    }
    

    
    /// Generates an image containing the passed string following the path in the instance
    /// bezier path.
    /// - Notes:
    ///   - Depending on various settings, the starting point of the string will vary (especially
    ///     with animation enabled).
    /// - Parameters:
    ///   - string: NSAttributed string to be rendered.
    ///   - imageSize: Size of the image to be returned. If nil, twice the size to the center of the path is used.
    ///   - alignment: Text alignment. Default is `.Center`.
    ///   - offset: Offset value of the start of the text. Also used for animation.
    ///   - fitWidth: Determines if the text fits the width of the bezier.
    ///   - StartOffset: Starting offset. Used for centering.
    ///   - RotateChars: If true, the characers are rotated 180° along the tangent of the path.
    ///   - VerticalAdder: Vertical offset.
    ///   - HorizontalAdder: Horizontal offset.
    /// - Returns: `UIImage` containing the provided string following the bezier path on success, nil on error.
    func TextOnPath(withAttributed string: NSAttributedString,
                    size imageSize: CGSize? = nil,
                    align alignment: NSTextAlignment = .center,
                    y offset: CGFloat = 0,
                    fitWidth: Bool = false,
                    StartOffset: CGFloat,
                    RotateChars: Bool,
                    VerticalAdder: CGFloat = 0,
                    HorizontalAdder: CGFloat = 0,
                    GlobalCharPositions: inout [CGPoint]) -> UIImage?
    {
        let imageSize = imageSize ?? self.sizeThatFits()
        
        if imageSize.width <= 0 || imageSize.height <= 0
        {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        
        guard let ctx = UIGraphicsGetCurrentContext() else
        {
            return nil
            
        }
        
        let StringFont = UIFont(name: Settings.GetString(.ImageTextFont, "Avenir"),
                                size: Settings.GetCGFloat(.ImageTextFontSize, 32.0))
        //let StringFont = UIFont(name: "Voynich-123", size: 200.0)
        let Attributes = [NSAttributedString.Key.font: StringFont as Any,
                          NSAttributedString.Key.foregroundColor: Settings.GetColor(.TextColor, UIColor.black).cgColor as Any]
        let FinalString = NSAttributedString(string: string.string,
                                             attributes: Attributes)
        
        var FinalOffset = StartOffset
        #if false
        print("FinalOffset=\(FinalOffset)")
        let FinalLength = FinalString.size().width
        let FinalPathLength = self.PathLength
        FinalOffset = FinalPathLength / 2 - FinalLength / 2
        #else
        if !Settings.GetBool(.Animating)
        {
            let FinalLength = FinalString.size().width
            let FinalPathLength = self.PathLength
            //print("String length = \(Int(FinalLength)), Path length = \(Int(FinalPathLength))")
            FinalOffset = FinalPathLength / 2 - FinalLength / 2
        }
        #endif
        
        self.DrawTextOnPath(attributed: FinalString,
                            to: ctx,
                            align: alignment,
                            y: offset,
                            fitWidth: fitWidth,
                            StartOffset: FinalOffset,
                            RotateChars: RotateChars,
                            Size: imageSize,
                            PhraseAlignment: Settings.GetEnum(ForKey: .ShapeAlignment, EnumType: ShapeAlignments.self, Default: .None),
                            GlobalCharPositions: &GlobalCharPositions)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //print("image.size=\(image!.size)")
        
        return image
    }
    
    /// Return a size for the final image that fits the size of the path.
    /// - Notes: Assume the path is centered and has enough space on top and left to be able to accomodate the text.
    /// - Returns: Size of the final image based on the path.
    func sizeThatFits() -> CGSize
    {
        let bounds = path.boundingBoxOfPath
        let imageSize = CGSize(width: bounds.midX * 2, height: bounds.midY * 2)
        
        return imageSize
    }
}

// MARK: - Label

class UIBezierLabel: UILabel
{
    /// Set the CGPath, Bezier gets automatically generated.
    var bezierPath: CGPath?
    {
        get
        {
            return bezier?.path
        }
        set
        {
            if let path = newValue
            {
                bezier = Bezier(path: path)
            }
            else
            {
                bezier = nil
            }
        }
    }
    
    var bezier: Bezier?
    {
        didSet
        {
            self.numberOfLines = 1
        }
    }
    
    /// Y offset offset above or below the centerline in units of line height, default is 0.
    var textPathOffset: CGFloat = 0
    
    // .Justify doesn't work on UILabels
    private var _textAlignment: NSTextAlignment = .left
    override var textAlignment: NSTextAlignment
    {
        willSet
        {
            _textAlignment = newValue
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect)
    {
        if let bezier = bezier, let string = self.attributedText, let ctx = UIGraphicsGetCurrentContext()
        {
            var GlobalCharPositions = [CGPoint]()
            bezier.DrawTextOnPath(attributed: string,
                                  to: ctx,
                                  align: _textAlignment,
                                  y: textPathOffset,
                                  fitWidth: adjustsFontSizeToFitWidth,
                                  RotateChars: false,
                                  Size: CGSize(width: 400, height: 400),
                                  PhraseAlignment: Settings.GetEnum(ForKey: .ShapeAlignment, EnumType: ShapeAlignments.self, Default: .None),
                                  GlobalCharPositions: &GlobalCharPositions)
        }
        else
        {
            super.draw(rect)
        }
    }
    
    /// Works according to the dimensions of the bezier path, not the text
    override func sizeThatFits(_ size: CGSize) -> CGSize
    {
        if let bezier = bezier
        {
            return bezier.sizeThatFits()
        }
        
        return super.sizeThatFits(size)
    }
}

/// Extension for CGPoint that returns a tuple of integer values for `x` and `y`.
extension CGPoint
{
    /// Return `x` and `y` as a tuple of integers.
    func AsInt() -> (X: Int, Y: Int)
    {
        return (Int(self.x), Int(self.y))
    }
}
