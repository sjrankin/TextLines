//
//  +SettingsChangedHandler.swift
//  SettingsChangedHandler
//
//  Created by Stuart Rankin on 8/15/21.
//

import Foundation
import UIKit

extension ViewController: SettingChangedProtocol
{
    // MARK: - Setting changed handler
    
    func SubscriberID() -> UUID
    {
        return ClassID
    }
    
    /// Handle changes that affect TextLine overall or that need to take place at a main program level. Other
    /// changes may be handled lower in the code.
    /// - Parameter Setting: The setting that changed.
    /// - Parameter OldValue: The value of the setting before it was changed. May be nil.
    /// - Parameter NewValue: The new value of the setting. May be nil.
    func SettingChanged(Setting: SettingKeys, OldValue: Any?, NewValue: Any?)
    {
        let Current = Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
        switch Setting
        {
            case .CurrentShape:
                if let OldShape = PreviousShape
                {
                    if OldShape == Current
                    {
                        return
                    }
                }
                PreviousShape = Current
                
            case .UserShapes:
                break
                
            case .Animating:
                CommandButtonList = Settings.GetStrings(.CommandButtonList,
                                                        Delimiter: ",",
                                                        Default: [CommandButtons.ActionButton.rawValue])
                CmdController?.UpdateButtons(NewButtons: CommandButtonList)

            case .CommandButtonList:
                CommandButtonList = Settings.GetStrings(.CommandButtonList,
                                                        Delimiter: ",",
                                                        Default: [CommandButtons.ActionButton.rawValue])
                CmdController?.UpdateButtons(NewButtons: CommandButtonList)
                
            default:
                break
        }
        UpdateOutput()
    }
}
