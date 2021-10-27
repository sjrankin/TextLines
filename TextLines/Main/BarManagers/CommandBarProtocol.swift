//
//  CommandBarProtocol.swift
//  TextLines
//
//  Created by Stuart Rankin on 10/26/21.
//

import Foundation
import UIKit

protocol CommandBarProtocol: AnyObject
{
    func ExecuteCommand(_ sender: CommandBarManager, Command: CommandButtons)
    func LongTapOn(_ sender: CommandBarManager, Command: CommandButtons)
    func DoubleTap(_ sender: CommandBarManager, Command: CommandButtons)
    func CommandButtonSize(_ sender: CommandBarManager, Command: CommandButtons) -> CGSize?
    func ButtonColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?
    func TitleColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?
    func ButtonHorizontalGap(_ sender: CommandBarManager) -> CGFloat
}
