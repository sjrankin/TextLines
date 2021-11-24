//
//  +Anything.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/23/21.
//

import Foundation
import UIKit

extension Settings
{
    static func SetDefault(For Key: SettingKeys)
    {
        let TypeName = "\(Settings.SettingKeyTypes[Key]!)"
        switch TypeName
        {
            case "Bool":
                Settings.SetBool(Key, (SettingDefaults[Key] as? Bool)!)
                
            case "CGFloat":
                Settings.SetCGFloat(Key, (SettingDefaults[Key] as? CGFloat)!)
                
            case "CGPoint":
                Settings.SetCGPoint(Key, (SettingDefaults[Key] as? CGPoint)!)
                
            case "CGRect":
                Settings.SetRect(Key, (SettingDefaults[Key] as? CGRect)!)
                
            case "Date":
                Settings.SetDate(Key, (SettingDefaults[Key] as? Date)!)
                
            case "Double":
                Settings.SetDouble(Key, (SettingDefaults[Key] as? Double)!)
                
            case "Int":
                Settings.SetInt(Key, (SettingDefaults[Key] as? Int)!)
                
            case "String":
                Settings.SetString(Key, (SettingDefaults[Key] as? String)!)
                
            case "[String]":
                Settings.SetStrings(Key, (SettingDefaults[Key] as? [String])!)
                
            case "UIColor":
                Settings.SetColor(Key, (SettingDefaults[Key] as? UIColor)!)
                
            case "UUID":
                Settings.SetUUID(Key, (SettingDefaults[Key] as? UUID)!)
                
            case "ShapeCategories":
                Settings.SetEnum((SettingDefaults[Key] as? ShapeCategories)!,
                                 EnumType: ShapeCategories.self, ForKey: Key)
                
            case "Backgrounds":
                Settings.SetEnum((SettingDefaults[Key] as? Backgrounds)!,
                                 EnumType: Backgrounds.self, ForKey: Key)
                
            case "ShapeAlignments":
                Settings.SetEnum((SettingDefaults[Key] as? ShapeAlignments)!,
                                 EnumType: ShapeAlignments.self, ForKey: Key)
                
            case "LineOptions":
                Settings.SetEnum((SettingDefaults[Key] as? LineOptions)!,
                                 EnumType: LineOptions.self, ForKey: Key)
                
            case "LineStyles":
                Settings.SetEnum((SettingDefaults[Key] as? LineStyles)!,
                                 EnumType: LineStyles.self, ForKey: Key)
                
            default:
                Debug.Print("Unknown type in \(#function): \(TypeName)")
        }
    }
    
    /// Return any saved value as a string.
    /// - Note: This function must be updated as new enums and types are added to the
    ///         Setting system.
    /// - Parameter Key: The setting key whose value is returned.
    /// - Returns: String representation of the value stored in `Key`. Nil on error or
    ///            no value.
    static func GetStringed(_ Key: SettingKeys) -> String?
    {
        let TypeName = "\(Settings.SettingKeyTypes[Key]!)"
        switch TypeName
        {
            case "Bool":
                return "\(Settings.GetBool(Key))"
                
            case "CGFloat":
                return "\(Settings.GetCGFloat(Key))"
                
            case "CGPoint":
                return "\(Settings.GetCGPoint(Key)!)"
                
            case "CGRect":
                return "\(Settings.GetRect(Key)!)"
                
            case "Date":
                return "\(Settings.GetDate(Key))"
                
            case "Double":
                return "\(Settings.GetDouble(Key))"
                
            case "Int":
                return "\(Settings.GetInt(Key))"
                
            case "String":
                return Settings.GetString(Key)
                
            case "[String]":
                return "\(Settings.GetStrings(Key, Default: [""]))"
                
            case "UIColor":
                return "\(Settings.GetColor(Key, UIColor.black).Hex)"
                
            case "UUID":
                return "\(Settings.GetUUID(Key))"
                
            case "ShapeCategories":
                return "\(Settings.GetEnum(ForKey: Key, EnumType: ShapeCategories.self)!)"
                
            case "Backgrounds":
                return "\(Settings.GetEnum(ForKey: Key, EnumType: Backgrounds.self)!)"
                
            case "ShapeAlignments":
                return "\(Settings.GetEnum(ForKey: Key, EnumType: ShapeAlignments.self)!)"
           
            case "LineOptions":
                return "\(Settings.GetEnum(ForKey: Key, EnumType: LineOptions.self)!)"
                
            case "LineStyles":
                return "\(Settings.GetEnum(ForKey: Key, EnumType: LineStyles.self)!)"
                
            default:
                Debug.Print("Unknown type in \(#function): \(TypeName)")
                return nil
        }
    }
}
