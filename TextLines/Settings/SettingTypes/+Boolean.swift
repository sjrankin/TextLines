//
//  +Boolean.swift
//  +Boolean
//
//  Created by Stuart Rankin on 7/19/21. Adapted from Flatland View.
//

import Foundation
import UIKit

extension Settings
{
    // MARK: - Boolean functions.
    
    /// Initialize a Boolean setting. Subscribers are not notified.
    /// - Parameter Setting: The setting of the boolean to initialize.
    /// - Parameter Value: The initial value of the setting.
    public static func InitializeBool(_ Setting: SettingKeys, _ Value: Bool)
    {
        UserDefaults.standard.set(Value, forKey: Setting.rawValue)
    }
    
    /// Return a boolean setting value.
    /// - Parameter Setting: The setting whose boolean value will be returned.
    /// - Returns: Boolean value of the setting.
    public static func GetBool(_ Setting: SettingKeys) -> Bool
    {
        guard TypeIsValid(Setting, Type: Bool.self) else
        {
            Debug.FatalError("\(Setting) is not a boolean")
        }
        return UserDefaults.standard.bool(forKey: Setting.rawValue)
    }
    
    /// Queries a boolean setting value.
    /// - Parameter Setting: The setting whose boolean value will be passed to the completion handler.
    /// - Parameter Completion: Code to execute after the value is retrieved. The value is passed
    ///                         to the completion handler.
    public static func QueryBool(_ Setting: SettingKeys, Completion: (Bool) -> Void)
    {
        guard TypeIsValid(Setting, Type: Bool.self) else
        {
            Debug.FatalError("\(Setting) is not a boolean")
        }
        let BoolValue = UserDefaults.standard.bool(forKey: Setting.rawValue)
        Completion(BoolValue)
    }
    
    /// Save a boolean value to the specfied setting.
    /// - Warning: Throws a fatal error if `Setting` does not resolve to a boolean setting.
    /// - Parameter Setting: The setting that will be updated.
    /// - Parameter Value: The new value.
    public static func SetBool(_ Setting: SettingKeys, _ Value: Bool)
    {
        guard TypeIsValid(Setting, Type: Bool.self) else
        {
            Debug.FatalError("\(Setting) is not a boolean")
        }
        let OldValue = UserDefaults.standard.bool(forKey: Setting.rawValue)
        let NewValue = Value
        UserDefaults.standard.set(NewValue, forKey: Setting.rawValue)
        NotifySubscribers(Setting: Setting, OldValue: OldValue, NewValue: NewValue)
    }
    
    /// Sets a `true` value to the passed setting.
    /// - Warning: Throws a fatal error if `Setting` does not resolve to a boolean setting.
    /// - Note: Calls `SetBool(SettingKeys, Bool)`.
    /// - Parameter Setting: The setting that will have a `true` written to it.
    public static func SetTrue(_ Setting: SettingKeys)
    {
        SetBool(Setting, true)
    }
    
    /// Sets a `false` value to the passed setting.
    /// - Warning: Throws a fatal error if `Setting` does not resolve to a boolean setting.
    /// - Note: Calls `SetBool(SettingKeys, Bool)`.
    /// - Parameter Setting: The setting that will have a `false` written to it.
    public static func SetFalse(_ Setting: SettingKeys)
    {
        SetBool(Setting, false)
    }
    
    /// Inverts the boolean value at the specified setting and returns the new value. The inverted
    /// value is saved and any subscribers are notified of changes.
    /// - Parameter Setting: The setting where the boolean value to invert lives.
    /// - Parameter SendNotification: If true, a notification is sent when this function is called.
    ///                               If false, subscribers are not notified.
    /// - Returns: Inverted value found at `Setting`.
    @discardableResult public static func InvertBool(_ Setting: SettingKeys, SendNotification: Bool = true) -> Bool
    {
        let OldBool = GetBool(Setting)
        let NewBool = !OldBool
        UserDefaults.standard.set(NewBool, forKey: Setting.rawValue)
        if SendNotification
        {
            NotifySubscribers(Setting: Setting, OldValue: OldBool, NewValue: NewBool)
        }
        return NewBool
    }
    
    /// Thin wrapper around `InvertBool`. Inverts the boolean value at the specified setting and returns the new value.
    /// The inverted value is saved and any subscribers are notified of changes.
    /// - Parameter Setting: The setting where the boolean value to invert lives.
    /// - Parameter SendNotification: If true, a notification is sent when this function is called.
    ///                               If false, subscribers are not notified.
    /// - Returns: Inverted value found at `Setting`.
    @discardableResult public static func ToggleBool(_ Setting: SettingKeys, SendNotification: Bool = true) -> Bool
    {
        return InvertBool(Setting, SendNotification: SendNotification)
    }
    
    /// Queries an inverted boolean setting value.
    /// - Note: The boolean value is inverted and saved back to the same `Setting` location prior to the
    ///         closure being called.
    /// - Parameter Setting: The setting whose inverted boolean value will be passed to the completion handler.
    /// - Parameter Completion: Code to execute after the value is retrieved. The inverted value is passed
    ///                         to the completion handler.
    public static func QueryInvertBool(_ Setting: SettingKeys, Completion: (Bool) -> Void)
    {
        guard TypeIsValid(Setting, Type: Bool.self) else
        {
            Debug.FatalError("\(Setting) is not a boolean")
        }
        var BoolValue = UserDefaults.standard.bool(forKey: Setting.rawValue)
        BoolValue = !BoolValue
        UserDefaults.standard.set(BoolValue, forKey: Setting.rawValue)
        Completion(BoolValue)
    }
    
    /// Compares all boolean values in the passed list of setting keys to the value of `Are`.
    /// - Warning: If any `SettingKey` in `BoolList` is not a Boolean, a fatal error is thrown.
    /// - Parameter BoolList: Array of `SettingKeys` whose values will be tested. **Must** all be of
    ///                       Boolean type. If not, a fatal error is thrown.
    /// - Parameter Are: The value to test all values in `BoolList` against.
    /// - Returns: All values in `BoolList` must match this value for `true` to be returned. Otherwise,
    ///            false is returned. Additionally, false is returned if `BoolList` is empty.
    public static func AllBools(_ BoolList: [SettingKeys], Are: Bool) -> Bool
    {
        if BoolList.count < 1
        {
            return false
        }
        for SomeSetting in BoolList
        {
            if !TypeIsValid(SomeSetting, Type: Bool.self)
            {
                fatalError("\(SomeSetting) is not a boolean")
            }
            let SomeValue = GetBool(SomeSetting)
            if SomeValue != Are
            {
                return false
            }
        }
        return true
    }
    
    /// Determines if all Boolean settings in `InList` are true.
    /// - Note: See also `AllBools`.
    /// - Warning: If any `SettingKey` in `InList` is not a Boolean, a fatal error will the thrown.
    /// - Parameter InList: Set of Boolean `SettingKeys` to compare to `true`.
    /// - Returns: True if all values in `InList` are true, false otherwise (including no values in `InList`).
    public static func AllBoolsAreTrue(_ InList: [SettingKeys]) -> Bool
    {
        return AllBools(InList, Are: true)
    }
    
    /// Determines if all Boolean settings in `InList` are false.
    /// - Note: See also `AllBools`.
    /// - Warning: If any `SettingKey` in `InList` is not a Boolean, a fatal error will the thrown.
    /// - Parameter InList: Set of Boolean `SettingKeys` to compare to `false`.
    /// - Returns: True if all values in `InList` are false, false otherwise (including no values in `InList`).
    public static func AllBoolsAreFalse(_ InList: [SettingKeys]) -> Bool
    {
        return AllBools(InList, Are: false)
    }
}
