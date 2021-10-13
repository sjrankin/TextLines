//
//  +UUID.swift
//  TextLine
//
//  Created by Stuart Rankin on 10/6/21.
//

import Foundation
import UIKit

extension Settings
{
    // MARK: - String functions.
    
    /// Initialize a UUID setting. Subscribers are not notified.
    /// - Parameter Setting: The setting of the string to initialize.
    /// - Parameter Value: The initial value of the setting.
    public static func InitializeUUID(_ Setting: SettingKeys, _ Value: UUID)
    {
        let Writeable = Value.uuidString
        UserDefaults.standard.set(Writeable, forKey: Setting.rawValue)
    }
    
    /// Returns a UUID from the specified setting.
    /// - Warning: Throws a fatal error if the type stored is not a UUID or if the stored value
    ///            cannot be converted to a UUID.
    /// - Parameter Setting: The setting whose UUID value will be returned.
    /// - Parameter Default: If the setting does not exist, this value will be set, then returned.
    /// - Returns: UUID found at the specified setting, or `Default` if it does not exist.
    public static func GetUUID(_ Setting: SettingKeys, _ Default: UUID = UUID.Empty) -> UUID
    {
        guard TypeIsValid(Setting, Type: UUID.self) else
        {
            Debug.FatalError("\(Setting) is not a UUID")
        }
        if let Raw = UserDefaults.standard.string(forKey: Setting.rawValue)
        {
            if let Final = UUID(uuidString: Raw)
            {
                return Final
            }
            Debug.FatalError("Unable to converted stored value to UUID.")
        }
        UserDefaults.standard.set(Default.uuidString, forKey: Setting.rawValue)
        return Default
    }
    
    /// Returns a UUID from the specified setting.
    /// - Warning: Throws a fatal error if the type stored is not a UUID or if the stored value
    ///            cannot be converted to a UUID.
    /// - Parameter Setting: The setting whose UUID value will be returned.
    /// - Returns: UUID found at the specified setting. If the value is empty or cannot be converted
    ///            to a UUID, nil is returned.
    public static func GetNillableUUID(_ Setting: SettingKeys) -> UUID?
    {
        guard TypeIsValid(Setting, Type: UUID.self) else
        {
            Debug.FatalError("\(Setting) is not a UUID")
        }
        if let Raw = UserDefaults.standard.string(forKey: Setting.rawValue)
        {
            if let Final = UUID(uuidString: Raw)
            {
                return Final
            }
        }
        return nil
    }
    
    /// Save a UUID at the specified setting.
    /// - Warning: Throws a fatal error if the type stored is not a UUID.
    /// - Parameter Setting: The setting where the UUID value will be saved.
    /// - Parameter Value: The value to save.
    public static func SetUUID(_ Setting: SettingKeys, _ Value: UUID)
    {
        guard TypeIsValid(Setting, Type: UUID.self) else
        {
            Debug.FatalError("\(Setting) is not a UUID")
        }
        let OldValue = GetUUID(Setting)
        let NewValue = Value
        let AsRaw = Value.uuidString
        UserDefaults.standard.set(AsRaw, forKey: Setting.rawValue)
        NotifySubscribers(Setting: Setting, OldValue: OldValue, NewValue: NewValue)
    }
}
