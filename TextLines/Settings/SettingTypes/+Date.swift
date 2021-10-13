//
//  +Date.swift
//  +Date
//
//  Created by Stuart Rankin on 7/19/21. Adapted from Flatland View.
//

import Foundation
import UIKit

extension Settings
{
    // MARK: - Date-based settings.
    
    /// Initialize a date settings. No notification is sent to subscribers.
    /// - Note: Internally, dates are saved as a double with the value being the number of seconds
    ///         since 1970.
    /// - Parameter NewValue: The value to set.
    /// - Parameter ForKey: The setting key.
    public static func InitializeDate(_ NewValue: Date, ForKey: SettingKeys)
    {
        UserDefaults.standard.set(NewValue.timeIntervalSince1970, forKey: ForKey.rawValue)
    }
    
    /// Returns a date from the specified setting.
    /// - Parameter Setting: The setting key whose date value will be returned.
    /// - Returns: The date stored in the specified setting key. May be 1 January 1970 if not
    ///            previously set.
    public static func GetDate(_ Setting: SettingKeys) -> Date
    {
        if !TypeIsValid(Setting, Type: Date.self)
        {
            fatalError("\(Setting) is not a Date")
        }
        let Raw = UserDefaults.standard.double(forKey: Setting.rawValue)
        return Date(timeIntervalSince1970: Raw)
    }
    
    /// Returns a date from the specified setting. If the date appears to have not been set previously,
    /// the value in `IfZero` is returned (as well as being saved to the specified setting key).
    /// - Parameter Setting: The setting key whose date value will be returned.
    /// - Parameter IfZero: The value to save and return if the key holds `0.0` (which indicates
    ///                     no value has previously been stored.
    /// - Returns: The date stored in the specified setting, the value of `IfZero` if no previous
    ///            date was stored.
    public static func GetDate(_ Setting: SettingKeys, _ IfZero: Date) -> Date
    {
        if !TypeIsValid(Setting, Type: Date.self)
        {
            fatalError("\(Setting) is not a Date")
        }
        let Raw = UserDefaults.standard.double(forKey: Setting.rawValue)
        if Raw == 0.0
        {
            SetDate(Setting, IfZero)
            return IfZero
        }
        return Date(timeIntervalSince1970: Raw)
    }
    
    /// Save the passed date to the specified setting.
    /// - Parameter Setting: The setting key where to save the date.
    /// - Parameter Value: The value to save.
    public static func SetDate(_ Setting: SettingKeys, _ Value: Date)
    {
        if !TypeIsValid(Setting, Type: Date.self)
        {
            fatalError("\(Setting) is not a Date")
        }
        let OldValue = GetDate(Setting)
        UserDefaults.standard.set(Value.timeIntervalSince1970, forKey: Setting.rawValue)
        NotifySubscribers(Setting: Setting, OldValue: OldValue, NewValue: Value)
    }
}
