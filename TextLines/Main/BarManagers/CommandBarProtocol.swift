//
//  CommandBarProtocol.swift
//  TextLines
//
//  Created by Stuart Rankin on 10/26/21.
//

import Foundation
import UIKit

/// Protocol for the command bar control.
protocol CommandBarProtocol: AnyObject
{
    /// Called by the command bar when the user taps on a command.
    /// - Parameter sender: The command bar control where the user tapped.
    /// - Parameter Command: The command the user tapped.
    func ExecuteCommand(_ sender: CommandBarManager, Command: CommandButtons)
    
    /// Called by the command bar when the user long taps on a command.
    /// - Parameter sender: The command bar control where the user long tapped.
    /// - Parameter Command: The command the user tapped.
    func LongTapOn(_ sender: CommandBarManager, Command: CommandButtons)
    
    /// Called by the command bar when the user double taps on a command.
    /// - Parameter sender: The command bar control where the user double tapped.
    /// - Parameter Command: The command the user tapped.
    func DoubleTap(_ sender: CommandBarManager, Command: CommandButtons)
    
    /// Called by the command bar when a command button needs to be sized.
    /// - Parameter sender: The command bar control that wants the size of buttons.
    /// - Parameter Command: The button that needs a size.
    /// - Returns: The size of the button as determined by the client.
    func CommandButtonSize(_ sender: CommandBarManager, Command: CommandButtons) -> CGSize?
    
    /// Called by the command bar when a command button need the color of the button image.
    /// - Note: Only the image is colored. Call `TitleColor` to set the title's text color.
    /// - Parameter sender: The command bar control that wants the color of the button.
    /// - Parameter Command: The button that needs a color.
    /// - Returns: The color of the button as determined by the client.
    func ButtonColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?

    /// Called by the command bar when a command button need the color of the title.
    /// - Note: Only the image is colored. Call `ButtonColor` to set the image's color.
    /// - Parameter sender: The command bar control that wants the color of the text.
    /// - Parameter Command: The button that needs a color for the text.
    /// - Returns: The color of the text as determined by the client.
    func TitleColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?
    
    /// Called by the command bar when a command button needs the font size of a title.
    /// - Parameter sender: The command bar control that wants the title font size.
    /// - Parameter Command: The button that needs the title font size
    /// - Returns: The font size of the text as determined by the client.
    func TitleFontSize(_ sender: CommandBarManager, Command: CommandButtons) -> CGFloat
    
    /// Called by the command bar when commands are being added to the host `UIScrollView`.
    /// Provides the horizontal gap between buttons.
    /// - Parameter sender: The command bar control that wants the gap between buttons.
    /// - Returns: Horizontal gap between buttons.
    func ButtonHorizontalGap(_ sender: CommandBarManager) -> CGFloat

    /// Called by the command bar when commands are being added to the host `UIScrollView`.
    /// Determines whether or not to display titles. Affects all buttons in the command bar.
    /// - Parameter sender: The command bar control that wants the title visiblity flag.
    /// - Returns: True if titles should be displayed, false if not.
    func HasTitles(_ sender: CommandBarManager) -> Bool
    
    /// Not currently used.
    func ShapeGroupSelected(_ sender: CommandBarManager, NewCategory: ShapeCategories)
    /// Not currently used.
    func ShapeSelected(_ sender: CommandBarManager, NewShape: Shapes)
    /// Not currently used.
    func HighlightTappedButtons(_ sender: CommandBarManager) -> Bool
}
