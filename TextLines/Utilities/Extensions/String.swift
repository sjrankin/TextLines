//
//  String.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/24/21.
//

import Foundation
import UIKit

/// MARK: - String extensions.

public extension String
{
    /// Return a `CGPath` based on the passed string.
    /// - Note: See [CGPath from String](https://stackoverflow.com/questions/9976454/cgpathref-from-string)
    /// - Parameter Font: The font to use for the instance string to generate a path.
    /// - Returns: Path for the instance string.
    func Path(withFont Font: UIFont) -> CGPath
    {
        let attributedString = NSAttributedString(string: self, attributes: [.font: Font])
        let path = attributedString.Path()
        return path
    }
}
