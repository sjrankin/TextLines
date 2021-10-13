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
        #if true
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
                
            case .ActionIconName:
                let NewName = Settings.GetString(.ActionIconName, "CogIcon")
                ActionImage.image = UIImage(named: NewName)
                ActionImage.image = ActionImage.image?.withRenderingMode(.alwaysTemplate)
                ActionImage.tintColor = UIColor.systemBlue
                return
                
            default:
                break
        }
        UpdateOutput()
        #else
        let Current = Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
        switch Setting
        {
            case .CurrentShape:
                UpdateOutput()
                
            case .CircleAngle, .CircleDiameter:
                if Current == .Circle
                {
                    UpdateOutput()
                }
                
            case .EllipseHeight, .EllipseLength:
                if Current == .Ellipse
                {
                    UpdateOutput()
                }
                
            case .ClockwiseText:
                print("ClockwiseText change detected.")
                
            case .TextColor, .GuidelineColor, .ImageTextFontSize, .ImageTextFont,
                    .BackgroundColor, .ImageWidth, .ImageHeight:
                UpdateOutput()
                
            default:
                Debug.Print("Unhandled settings change: \(Setting)")
        }
        #endif
    }
}
