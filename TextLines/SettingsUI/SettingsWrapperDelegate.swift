//
//  SettingsWrapperDelegate.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/3/21.
//

import Foundation
import UIKit

protocol SettingsWrapperDelegate: AnyObject
{
    func GetTarget() -> (StoryboardName: String, ControllerName: String)?
}
