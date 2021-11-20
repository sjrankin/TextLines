//
//  UIConstants.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/20/21.
//

import Foundation
import UIKit

/// Constants-related to the UI and not defined in the `.nib` file.
class UIConstants
{
    // MARK: - Main UI
    
    /// Width of command bar icons.
    public static let MainIconWidth: CGFloat = 55.0
    /// Height of command bar icons.
    public static let MainIconHeight: CGFloat = 55.0
    /// Default value of the width of command bar icons.
    public static let DefaultIconWidth: CGFloat = 50.0
    /// Default value of the height of command bar icons.
    public static let DefaultIconHeight: CGFloat = 50.0
    /// Standard view corner radius.
    public static let CornerRadius: CGFloat = 5.0
    /// Drag bar corner radius.
    public static let DragCornerRadius: CGFloat = 4.0
    /// Standard view border thickness.
    public static let BorderThickness: CGFloat = 0.5
    /// Standard view border color.
    public static let BorderColor: CGColor = UIColor.gray.cgColor
    /// Z-level value for moving views out of the way.
    public static let HiddenZ: CGFloat = -1000.0
    /// Z-level value for moving views into view.
    public static let VisibleZ: CGFloat = 1000.0
    /// Z-level value for moving the slice panel out of the way.
    public static let HiddenSliceZ: CGFloat = -2000.0
    
    // MARK: - Short message view.
    
    /// Z-level value for the short message view when visible.
    public static let ShowMessageZ: CGFloat = 2000.0
    /// Number of seconds to wait before starting to fade the short message.
    public static let BeforeFadeDuration: Double = 1.5
    /// Number of seconds to fade out the standard message.
    public static let StandardFadeDuration: Double = 2.0
    /// Number of seconds to fade out for error messages.
    public static let ErrorFadeDuration: Double = 3.5
    /// Final fade alpha value. Must be at least 0.05.
    public static let FinalFadeAlpha: CGFloat = 0.05
    
    // MARK: - Command var.
    
    /// Default horizontal gap between buttons.
    public static let HorizontalGap: CGFloat = 10.0
    /// Initial gap for command buttons.
    public static let InitialGap: CGFloat = 16.0
    /// Long press duration for command bar.
    public static let CommandLongPressDuration: Double = 0.75
    /// Width of the title label for command buttons.
    public static let ButtonLabelWidth: CGFloat = 60.0
    /// Height of the title label for command buttons.
    public static let ButtonLabelHeight: CGFloat = 20.0
    /// Default font size for command button labels.
    public static let ButtonLabelDefaultFontSize: CGFloat = 14.0
    /// Final command button height.
    public static let FinalButtonHeight: CGFloat = 80.0
    /// Y location of the command button.
    public static let ButtonYLocation: CGFloat = 5.0
}
