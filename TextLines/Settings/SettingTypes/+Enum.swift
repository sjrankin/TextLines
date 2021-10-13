//
//  +Enum.swift
//  +Enum
//
//  Created by Stuart Rankin on 7/19/21. Adapted from Flatland View.
//

import Foundation
import UIKit

extension Settings
{
    // MARK: - Enum-based settings.
    
    /// Initialize an Enum-based setting. No notification is sent to subscribers.
    /// - Warning: A fatal error is generated if `NewValue` has a different type from `EnumType`.
    /// - Parameter NewValue: The value to set.
    /// - Parameter EnumType: The type of enum to save.
    /// - Parameter ForKey: The setting key.
    public static func InitializeEnum<T: RawRepresentable>(_ NewValue: T, EnumType: T.Type, ForKey: SettingKeys)
    {
        guard let _ = EnumType.init(rawValue: NewValue.rawValue) else
        {
            Debug.FatalError("Invalid enum conversion. Most likely tried to convert an enum case from Enum type 'A' to Enum type 'B'.")
        }
        UserDefaults.standard.set(NewValue.rawValue, forKey: ForKey.rawValue)
    }
    
    /// Return an enum case value from user settings.
    /// - Warning: A fatal error is generated if `ForKey` does not point to a string setting.
    /// - Note: See: [Pass an enum type name](https://stackoverflow.com/questions/38793536/possible-to-pass-an-enum-type-name-as-an-argument-in-swift)
    /// - Parameter ForKey: The setting key that points to where the enum case is stored (as a string).
    /// - Parameter EnumType: The type of the enum to return.
    /// - Parameter Default: The default value returned for when `ForKey` has yet to be set.
    /// - Returns: Enum value (of type `EnumType`) for the specified setting key.
    public static func GetEnum<T: RawRepresentable>(ForKey: SettingKeys, EnumType: T.Type, Default: T) -> T where T.RawValue == String
    {
        guard TypeIsValid(ForKey, Type: EnumType.self) else
        {
            Debug.FatalError("\(ForKey) is not \(EnumType.self)")
        }
        if let Raw = GetMaskedString(ForKey)
        {
            guard let Value = EnumType.init(rawValue: Raw) else
            {
                return Default
            }
            return Value
        }
        return Default
    }
    
    /// Return an enum case value from user settings.
    /// - Warning: A fatal error is generated if `ForKey` does not point to a string setting.
    /// - Note: See: [Pass an enum type name](https://stackoverflow.com/questions/38793536/possible-to-pass-an-enum-type-name-as-an-argument-in-swift)
    /// - Parameter ForKey: The setting key that points to where the enum case is stored (as a string).
    /// - Parameter EnumType: The type of the enum to return.
    /// - Returns: Enum value (of type `EnumType`) for the specified setting key. Nil returned if the setting was not found.
    public static func GetEnum<T: RawRepresentable>(ForKey: SettingKeys, EnumType: T.Type) -> T? where T.RawValue == String
    {
        guard TypeIsValid(ForKey, Type: EnumType.self) else
        {
            Debug.FatalError("\(ForKey) is not \(EnumType.self)")
        }
        if let Raw = GetMaskedString(ForKey)
        {
            guard let Value = EnumType.init(rawValue: Raw) else
            {
                return nil
            }
            return Value
        }
        return nil
    }
    
    /// Determines if the enum value in `SettingKeys` is the same as `TestFor`.
    /// - Warning: A fatal error is generated if `EnumKey` does not point to a string setting.
    /// - Parameter TestFor: The value to test against the contents of `EnumKey`.
    /// - Parameter EnumKey: The location of the stored enum to test against `TestFor`.
    /// - Parameter EnumType: The type of enum being tested.
    /// - Returns: True if the stored enum value is the same as `TestFor`, false otherwise.
    public static func EnumIs<T: RawRepresentable>(_ TestFor: T, _ EnumKey: SettingKeys, EnumType: T.Type) -> Bool where T.RawValue == String
    {
        if let RawEnum = GetEnum(ForKey: EnumKey, EnumType: EnumType)
        {
            return RawEnum == TestFor
        }
        return false
    }
    
    /// Queries an enum setting value.
    /// - Warning: A fatal error is generated if `ForKey` does not point to a string setting.
    /// - Parameter Setting: The setting whose enum value will be passed to the completion handler.
    /// - Parameter Completion: Code to execute after the value is retrieved. The value is passed
    ///                         to the completion handler.
    public static func QueryEnum<T: RawRepresentable>(_ Setting: SettingKeys, EnumType: T.Type, Completion: (T?) -> Void) where T.RawValue == String
    {
        guard TypeIsValid(Setting, Type: EnumType.self) else
        {
            Debug.FatalError("\(Setting) is not \(EnumType.self)")
        }
        let EnumValue = GetEnum(ForKey: Setting, EnumType: EnumType)
        Completion(EnumValue)
    }
    
    /// Saves an enum value to user settings. This function will convert the enum value into a string (so the
    /// enum *must* be `String`-based) and save that.
    /// - Warning: Fatal errors are generated if:
    ///   - `NewValue` is not from `EnumType`.
    ///   - `ForKey` does not point to a String setting.
    /// - Parameter NewValue: Enum case to save.
    /// - Parameter EnumType: The type of enum the `NewValue` is based on. If `NewValue` is not from `EnumType`,
    ///                       a fatal error will occur.
    /// - Parameter ForKey: The settings key to use to indicate where to save the value.
    /// - Parameter Completed: Closure called at the end of the saving process.
    public static func SetEnum<T: RawRepresentable>(_ NewValue: T, EnumType: T.Type, ForKey: SettingKeys,
                                                    Completed: ((SettingKeys) -> Void)) where T.RawValue == String
    {
        guard TypeIsValid(ForKey, Type: EnumType.self) else
        {
            Debug.FatalError("\(ForKey) is not \(EnumType.self)")
        }
        let OldValue = GetEnum(ForKey: ForKey, EnumType: EnumType.self)
        guard let _ = EnumType.init(rawValue: NewValue.rawValue) else
        {
            Debug.FatalError("Invalid enum conversion. Most likely tried to convert an enum case from Enum A to Enum B.")
        }
        UserDefaults.standard.set(NewValue.rawValue, forKey: ForKey.rawValue)
        Completed(ForKey)
        NotifySubscribers(Setting: ForKey, OldValue: OldValue, NewValue: NewValue)
    }
    
    /// Saves an enum value to user settings. This function will convert the enum value into a string (so the
    /// enum *must* be `String`-based) and save that.
    /// - Warning: Fatal errors are generated if:
    ///   - `NewValue` is not from `EnumType`.
    ///   - `ForKey` does not point to a String setting.
    /// - Parameter NewValue: Enum case to save.
    /// - Parameter EnumType: The type of enum the `NewValue` is based on. If `NewValue` is not from `EnumType`,
    ///                       a fatal error will occur.
    /// - Parameter ForKey: The settings key to use to indicate where to save the value.
    public static func SetEnum<T: RawRepresentable>(_ NewValue: T, EnumType: T.Type, ForKey: SettingKeys) where T.RawValue == String
    {
        guard TypeIsValid(ForKey, Type: EnumType.self) else
        {
            Debug.FatalError("\(ForKey) is not \(EnumType.self)")
        }
        let OldValue = GetEnum(ForKey: ForKey, EnumType: EnumType.self)
        guard let _ = EnumType.init(rawValue: NewValue.rawValue) else
        {
            Debug.FatalError("Invalid enum conversion. Most likely tried to convert an enum case from Enum type 'A' to Enum type 'B'.")
        }
        UserDefaults.standard.set(NewValue.rawValue, forKey: ForKey.rawValue)
        NotifySubscribers(Setting: ForKey, OldValue: OldValue, NewValue: NewValue)
    }
}
