//
//  CommandBarControlProtocol.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/19/21.
//

import Foundation
import UIKit

/// Protocol for controlling the command bar.
protocol CommandBarControlProtocol: AnyObject
{
    /// Returns the image for the passed command.
    /// - Parameter For: The command whose image is returned.
    /// - Parameter Size: Size of the image to return.
    /// - Parameter ButtonColor: The color of the image.
    /// - Returns: The image view for `For`.
    func ReturnButtonImage(For: CommandButtons, Size: CGSize,
                           ButtonColor: UIColor) -> UIImageView2
    
    /// Returns the title for the passed command button.
    /// - Parameter For: The command button whose title will be returned.
    /// - Returns: Title for the passed command button.
    func ReturnButtonTitle(For: CommandButtons) -> String
    
    /// Returns the title for the passed command button.
    /// - Parameter For: The command button whose title will be returned.
    /// - Returns: Title for the passed command button.
    func ReturnButtonLongTitle(For: CommandButtons) -> String
    
    /// Returns the name of the button image for the passed command button.
    /// - Parameter For: The command button whose image name will be returned.
    /// - Returns: Name of the image to use for the command.
    func ReturnButtonImageName(For: CommandButtons) -> String
}
