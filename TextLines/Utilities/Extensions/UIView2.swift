//
//  UIView2.swift
//  TextLines
//
//  Created by Stuart Rankin on 10/25/21.
//

import Foundation
import UIKit

/// Very small wrapper class around a `UIView` to provide a .Net-like Tag property
/// that can contain anything.
class UIView2: UIView
{
    /// Tag property. Defaults to `nil`.
    var Tag: Any? = nil
}
