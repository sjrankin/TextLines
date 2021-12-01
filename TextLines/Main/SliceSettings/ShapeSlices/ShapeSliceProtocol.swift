//
//  ShapeSliceProtocol.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/30/21.
//

import Foundation
import UIKit

/// Protocol for common functions in shape slice classes.
/// - Note: The protocol *must* be decorated with `@objc` in order for the `conforms`
///         API call to compile cleanly.
@objc protocol ShapeSliceProtocol
{
    /// Reset the current slice's settings to default values.
    func ResetSettings()
}
