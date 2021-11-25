//
//  NSAttributedString.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/24/21.
//

import Foundation
import UIKit

/// MARK: - NSAttributedString extensions.

public extension NSAttributedString
{
    /// Return a `CGPath` based on the instance `NSAttributedString` value.
    /// - Note: See [Path from string](https://stackoverflow.com/questions/9976454/cgpathref-from-string)
    /// - Returns: `CGPath` for the instance string.
    func Path() -> CGPath
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
