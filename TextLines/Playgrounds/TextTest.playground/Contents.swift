//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//https://stackoverflow.com/questions/9976454/cgpathref-from-string
public extension String
{
    func path(withFont font: UIFont) -> CGPath
    {
        let attributedString = NSAttributedString(string: self, attributes: [.font: font])
        let path = attributedString.path()
        return path
    }
}

//https://stackoverflow.com/questions/9976454/cgpathref-from-string
public extension NSAttributedString
{
    func path() -> CGPath
    {
        let path = CGMutablePath()
        
        // Use CoreText to lay the string out as a line
        let line = CTLineCreateWithAttributedString(self as CFAttributedString)
        
        // Iterate the runs on the line
        let runArray = CTLineGetGlyphRuns(line)
        let numRuns = CFArrayGetCount(runArray)
        for runIndex in 0 ..< numRuns
        {
            
            // Get the font for this run
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), to: CTRun.self)
            let runAttributes = CTRunGetAttributes(run) as Dictionary
            let runFont = runAttributes[kCTFontAttributeName] as! CTFont
            
            // Iterate the glyphs in this run
            let numGlyphs = CTRunGetGlyphCount(run)
            for glyphIndex in 0 ..< numGlyphs
            {
                let glyphRange = CFRangeMake(glyphIndex, 1)
                
                // Get the glyph
                var glyph : CGGlyph = 0
                withUnsafeMutablePointer(to: &glyph)
                {
                    glyphPtr in
                    CTRunGetGlyphs(run, glyphRange, glyphPtr)
                }
                
                // Get the position
                var position : CGPoint = .zero
                withUnsafeMutablePointer(to: &position)
                {
                    positionPtr in
                    CTRunGetPositions(run, glyphRange, positionPtr)
                }
                
                // Get a path for the glyph
                guard let glyphPath = CTFontCreatePathForGlyph(runFont, glyph, nil) else
                {
                    continue
                }
                
                // Transform the glyph as it is added to the final path
                let t = CGAffineTransform(translationX: position.x, y: position.y)
                path.addPath(glyphPath, transform: t)
            }
        }
        
        return path
    }
}

class MyViewController : UIViewController
{
    override func loadView()
    {
        TextView = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                       width: 220,
                                        height: 220))
        TextView.backgroundColor = .systemYellow
        
        self.view = TextView
        
        let test = PlotPoints()
        let SLayer = CAShapeLayer()
        SLayer.frame = TextView.frame
        SLayer.path = test.cgPath
        SLayer.strokeColor = UIColor.black.cgColor
        SLayer.lineWidth = 1.0
        TextView.layer.addSublayer(SLayer)
        print("View=\(self.view.frame)")
    }
    
    var TextView: UIView = UIView()
    var Points: [CGPoint] =
    [
        CGPoint(x: 10, y: 10),
        CGPoint(x: 200, y: 10),
        CGPoint(x: 200, y: 200),
        CGPoint(x: 10, y: 200),
        CGPoint(x: 110, y: 110)
    ]
    
    func PlotPoints() -> UIBezierPath
    {
        #if false
        let path = "Test Data".path(withFont: UIFont.systemFont(ofSize: 20.0))
        let Final = UIBezierPath(cgPath: path)
        let w = Final.bounds.width
        let h = Final.bounds.height
        Final.apply(CGAffineTransform(scaleX: 1.0, y: -1.0))
        Final.apply(CGAffineTransform(translationX: 110.0 - w / 2.0,
                                      y: 110.0 - h / 2.0))
        return Final
        #else
        let BezierPath = UIBezierPath()
        var Index = 1
        let TextFont = UIFont.systemFont(ofSize: 16.0)
        for SomePoint in Points
        {
            let Number = "\(Index)".path(withFont: TextFont)
            let NumberPath = UIBezierPath(cgPath: Number)
            let w = NumberPath.bounds.width
            let h = NumberPath.bounds.height
            NumberPath.apply(CGAffineTransform(scaleX: 1.0, y: -1.0))
            let Move = CGAffineTransform(translationX: SomePoint.x - w / 2.0,
                                         y: SomePoint.y + h / 2.0)
            NumberPath.apply(Move)
            BezierPath.append(NumberPath)
            Index = Index + 1
        }
        //BezierPath.move(to: CGPoint(x: 110, y: 110))
        return BezierPath
        #endif
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
