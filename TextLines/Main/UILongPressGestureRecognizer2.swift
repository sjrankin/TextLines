//
//  UILongPressGestureRecognizer2.swift
//  TextLines
//
//  Created by Stuart Rankin on 10/26/21.
//

import Foundation
import UIKit

/// Same as `UILongPressGestureRecognizer` but with added properties.
class UILongPressGestureRecognizer2: UILongPressGestureRecognizer
{
    /// Holds the current command button. Defaults to `.ActionButton`.
    private var _ForCommand: CommandButtons = .ActionButton
    /// Get or set the action button related to the gesture.
    var ForCommand: CommandButtons
    {
        get
        {
            return _ForCommand
        }
        set
        {
            _ForCommand = newValue
        }
    }
}
