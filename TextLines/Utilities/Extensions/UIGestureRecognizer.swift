//
//  UIGestureRecognizer.swift
//  TextLine
//
//  Created by Stuart Rankin on 10/1/21.
//

import Foundation
import UIKit

/// MARK: - UIGestureRecognizer extensions.
///
extension UIGestureRecognizer
{
    /// Cancel a gesture recognizer that hasn't ended.
    func CancelRecognizer()
    {
        isEnabled = false
        isEnabled = true
    }
}
