//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

extension Bezier {
    
    /**
     Adds the string to the provided context, following the bezier path
     
     - parameter string: NSAttributed string to be drawn on the context
     - parameter context: context to be drawn on
     - parameter align: text alignment, default is .Center
     - parameter y: y offset above or below the centerline in units of line height, default is 0
     */
    func draw(attributed string: NSAttributedString,
              to context: CGContext,
              align alignment: NSTextAlignment = .center,
              y offset: CGFloat = 0, fitWidth: Bool = false) {
        
        let pathLength = self.length()
        
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
        
        var ascent = Array(repeating: CGFloat(0), count: 3)
        let stringWidth = CGFloat(CTLineGetTypographicBounds(line, &ascent[0], &ascent[1], &ascent[2]))
        let height = ascent[0]-ascent[1]*2+ascent[2]*2
        
        let scale: CGFloat
        let spaceRemaining: CGFloat
        if fitWidth && pathLength < stringWidth {
            spaceRemaining = 0
            scale = min(1, pathLength / stringWidth)
        } else {
            spaceRemaining = pathLength - stringWidth
            scale = 1
        }
        
        if spaceRemaining < 0 {
            align = .justified
        } else {
            align = alignment
        }
        
        switch align {
            case .center:
                linePos = spaceRemaining / 2
                charSpacing = 0
            case .right:
                linePos = spaceRemaining
                charSpacing = 0
            case .justified:
                charSpacing = spaceRemaining / CGFloat(max(2,string.length-1))
                if string.length==1 {
                    linePos = charSpacing
                }
            default:
                charSpacing = 0
        }
        
        var glyphOffset:CGFloat = 0
        
        for r in 0..<CFArrayGetCount(runs) {
            
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runs, r), to: CTRun.self)
            let runCount = CTRunGetGlyphCount(run)
            
            let kern = (CTRunGetAttributes(run) as? [String:Any])?[NSKernAttributeName] as? CGFloat ?? 0
            
            var advances = Array(repeating: CGSize.zero, count: runCount)
            CTRunGetAdvances(run, CFRange(location: 0, length: runCount), &advances)
            
            for (i, advance) in advances.enumerated() {
                
                let width = advance.width-kern
                let length = linePos + width/2
                
                guard let p = self.properties(at: length) else { break }
                
                let textTransform = CGAffineTransform(scaleX: 1, y: -1)
                    .concatenating(CGAffineTransform(translationX: -glyphOffset-width/2/scale, y: height*(0.5+offset))
                                    .concatenating(CGAffineTransform(scaleX: scale, y: scale)
                                                    .concatenating(CGAffineTransform(rotationAngle: p.normal)
                                                                    .concatenating(CGAffineTransform(translationX: p.position.x, y: p.position.y)))))
                
                context.textMatrix = textTransform
                
                CTRunDraw(run, context, CFRange(location: i, length: 1))
                
                glyphOffset += width + kern
                linePos += (charSpacing + width + kern) * scale
            }
        }
        
        context.restoreGState()
    }
    
    /**
     Generates an image containing the string following the bezier path
     
     - parameter string: NSAttributed string to be rendered
     - parameter imageSize: size of the image to be returned. If nil, twice the size to the center of the path is used
     - parameter align: text alignment, default is .Center
     - parameter y: offset above or below the centerline in units of line height, default is 0
     
     - returns: UIImage containing the provided string following the bezier path
     */
    func image(withAttributed string: NSAttributedString,
               size imageSize: CGSize? = nil,
               align alignment: NSTextAlignment = .center,
               y offset: CGFloat = 0, fitWidth: Bool = false) -> UIImage? {
        
        let imageSize = imageSize ?? self.sizeThatFits()
        
        if imageSize.width <= 0 || imageSize.height <= 0 {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        self.draw(attributed: string, to: ctx, align: alignment, y: offset, fitWidth: fitWidth)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// something approximate ... assume the path is centered and has enough space on top and left to be able to accomodate the text
    func sizeThatFits() -> CGSize {
        let bounds = path.boundingBoxOfPath
        let imageSize = CGSize(width: bounds.midX*2, height: bounds.midY*2)
        
        return imageSize
    }
}

// MARK: - Label
class UIBezierLabel: UILabel {
    
    /// set the CGPath, Bezier gets automatically generated
    var bezierPath: CGPath? {
        get {
            return bezier?.path
        }
        set {
            if let path = newValue {
                bezier = Bezier(path: path)
            } else {
                bezier = nil
            }
        }
    }
    
    var bezier: Bezier? {
        didSet {
            self.numberOfLines = 1
        }
    }
    
    /// y offset offset above or below the centerline in units of line height, default is 0
    var textPathOffset: CGFloat = 0
    
    
    // .Justify doesn't work on UILabels
    private var _textAlignment: NSTextAlignment = .left
    override var textAlignment: NSTextAlignment {
        willSet {
            _textAlignment = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        if let bezier = bezier, let string = self.attributedText, let ctx = UIGraphicsGetCurrentContext() {
            bezier.draw(attributed: string, to: ctx, align: _textAlignment, y: textPathOffset, fitWidth: adjustsFontSizeToFitWidth)
        } else {
            super.draw(rect)
        }
    }
    
    /// works according to the dimensions of the bezier path, not the text
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let bezier = bezier {
            return bezier.sizeThatFits()
        }
        
        return super.sizeThatFits(size)
    }

class MyViewController : UIViewController
{
    override func loadView()
    {
        let view = UIView()
        view.backgroundColor = .white

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 50, y: 50+100))
        bezierPath.addCurve(to: CGPoint(x: 50+200, y: 50),
                            controlPoint1: CGPoint(x: 50+10, y: 50+75),
                            controlPoint2: CGPoint(x: 50+100, y: 50))
        bezierPath.addCurve(to: CGPoint(x: 50+400, y: 50+150),
                            controlPoint1: CGPoint(x: 50+300, y: 50),
                            controlPoint2: CGPoint(x: 50+400-10, y: 50+75))
        
        let attributedString = NSAttributedString(
            string: "Where did you come from, where did you go?",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.ultraLight),
                NSAttributedString.Key.foregroundColor: UIColor.red
            ])
        
        let bezier = UIBezierPath(cgPath: bezierPath.cgPath)
        
        // generate an image
        let image = bezier.image(withAttributed: attributedString)
        
        // or render onto a preexisting context
        bezier.draw(attributed: attributedString, to: UIGraphicsGetCurrentContext()!)
        
        self.view = view
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
