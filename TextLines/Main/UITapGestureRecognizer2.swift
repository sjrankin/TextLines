//
//  UITapGestureRecognizer2.swift
//  UITapGestureRecognizer2
//
//  Created by Stuart Rankin on 9/10/21.
//

import Foundation
import UIKit

/// Slightly modified `UITapGestureRecognizer` with a field holding a shape.
/// - Todo: Convert to an extension.
class UITapGestureRecognizer2: UITapGestureRecognizer
{
    /// Holds the current shape. Defaults to `.Circle`.
    private var _ForShape: Shapes = .Circle
    /// Get or set the shape related to the gesture.
    var ForShape: Shapes
    {
        get
        {
            return _ForShape
        }
        set
        {
            _ForShape = newValue
        }
    }
    
    /// Holds the current shape category. Defaults to `.Shapes`.
    private var _ForCategory: ShapeCategories = .Shapes
    /// Get or set the category related to the gesture.
    var ForCategory: ShapeCategories
    {
        get
        {
            return _ForCategory
        }
        set
        {
            _ForCategory = newValue
        }
    }
    
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
