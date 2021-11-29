//
//  +Double.swift
//  +Double
//
//  Created by Stuart Rankin on 7/19/21. Adapted from Flatland View.
//

import Foundation
import UIKit

extension Settings
{
    // MARK: - Double functions.
    
    /// Initialize a Double setting. Subscribers are not notified.
    /// - Parameter Setting: The setting of the double to initialize.
    /// - Parameter Value: The initial value of the setting.
    public static func InitializeDouble(_ Setting: SettingKeys, _ Value: Double)
    {
        UserDefaults.standard.set(Value, forKey: Setting.rawValue)
    }
    
    /// Initialize a Double? setting. Subscribers are not notified.
    /// - Parameter Setting: The setting of the double? to initialize.
    /// - Parameter Value: The initial value of the setting.
    public static func InitializeDoubleNil(_ Setting: SettingKeys, _ Value: Double? = nil)
    {
        guard TypeIsValid(Setting, Type: Double?.self) else
        {
            Debug.FatalError("\(Setting) is not a Double?")
        }
        if let Actual = Value
        {
            UserDefaults.standard.set(Double(Actual), forKey: Setting.rawValue)
        }
        else
        {
            UserDefaults.standard.set(nil, forKey: Setting.rawValue)
        }
    }
    
    /// Returns a double value from the specified setting.
    /// - Parameter Setting: The setting whose double value will be returned.
    /// - Returns: Double found at the specified setting.
    public static func GetDouble(_ Setting: SettingKeys) -> Double
    {
        guard TypeIsValid(Setting, Type: Double.self) else
        {
            Debug.FatalError("\(Setting) is not a Double")
        }
        return UserDefaults.standard.double(forKey: Setting.rawValue)
    }
    
    /// Returns a double from the specified setting but as an `Int` type.
    /// - Warning: A fatal error will be thrown if the type of `Setting` is not `Double`.
    /// - Parameter Setting: The setting whose value will be returned.
    /// - Returns: The double value found at the specified setting cast to an `Int`.
    public static func GetDoubleAsInt(_ Setting: SettingKeys) -> Int
    {
        guard TypeIsValid(Setting, Type: Double.self) else
        {
            Debug.FatalError("\(Setting) is not an Double")
        }
        let Value = UserDefaults.standard.double(forKey: Setting.rawValue)
        return Int(Value)
    }
    
    /// Returns a double value from the specified setting. This function assumes the
    /// value is a normal (`[0.0 ... 1.0]`) value.
    /// - Notes:
    ///   - If the setting key type is not `.Double`, a fatal error is thrown.
    ///   - If the value retrieved is not a normal (`[0.0 ... 1.0]`), it is truncated
    ///     to a normal range, saved, then returned.
    /// - Parameter Setting: The setting whose double value will be returned.
    /// - Returns: Double found at the specified setting.
    public static func GetDoubleNormal(_ Setting: SettingKeys) -> Double
    {
        guard TypeIsValid(Setting, Type: Double.self) else
        {
            Debug.FatalError("\(Setting) is not a Double")
        }
        let RawValue = UserDefaults.standard.double(forKey: Setting.rawValue)
        if RawValue < 0.0
        {
            UserDefaults.standard.set(0.0, forKey: Setting.rawValue)
        }
        if RawValue > 1.0
        {
            UserDefaults.standard.set(1.0, forKey: Setting.rawValue)
        }
        return RawValue
    }
    
    /// Save a double value at the specified setting.
    /// - Warning: If the setting type passed is not `Double`, a fatal error is thrown.
    /// - Note: Regardless if `Maximum` is used or not, all passed values are tested
    ///         to ensure they are in the range of [0.0 ... 1.0] and if not, truncated to
    ///         the range.
    /// - Parameter Setting: The setting where the double value will be stored.
    /// - Parameter Maximum: If a value is supplied, this function assumes it is the maximum
    ///                      possible value for the passed `Value` and divides `Value` by
    ///                      `Working`.
    /// - Parameter Value: The value to save.
    public static func SetDoubleNormal(_ Setting: SettingKeys, _ Value: Double,
                                       Maximum: Double? = nil)
    {
        guard TypeIsValid(Setting, Type: Double.self) else
        {
            Debug.FatalError("\(Setting) is not a Double")
        }
        var Working = Value
        if let MaxValue = Maximum
        {
            if MaxValue > 0.0
            {
                Working = Working / MaxValue
            }
        }
        if Working < 0.0
        {
            Working = 0.0
        }
        if Working > 1.0
        {
            Working = 1.0
        }
        let OldValue = UserDefaults.standard.double(forKey: Setting.rawValue)
        let NewValue = Working
        UserDefaults.standard.set(NewValue, forKey: Setting.rawValue)
        NotifySubscribers(Setting: Setting, OldValue: OldValue, NewValue: NewValue)
    }
    
    /// Queries a double setting value.
    /// - Parameter Setting: The setting whose double value will be passed to the completion handler.
    /// - Parameter Completion: Code to execute after the value is retrieved. The value is passed
    ///                         to the completion handler.
    public static func QueryDouble(_ Setting: SettingKeys, Completion: (Double) -> Void)
    {
        guard TypeIsValid(Setting, Type: Double.self) else
        {
            Debug.FatalError("\(Setting) is not a Double")
        }
        let DoubleValue = UserDefaults.standard.double(forKey: Setting.rawValue)
        Completion(DoubleValue)
    }
    
    /// Returns a double value from the specified setting, returning a passed value if the setting
    /// value is 0.0.
    /// - Parameter Setting: The setting whose double value will be returned.
    /// - Parameter IfZero: The value to return if the stored value is 0.0.
    /// - Returns: Double found at the specified setting, the value found in `IfZero` if the stored
    ///            value is 0.0.
    public static func GetDouble(_ Setting: SettingKeys, _ IfZero: Double = 0) -> Double
    {
        guard TypeIsValid(Setting, Type: Double.self) else
        {
            Debug.FatalError("\(Setting) is not a Double")
        }
        let Value = UserDefaults.standard.double(forKey: Setting.rawValue)
        if Value == 0.0
        {
            return IfZero
        }
        return Value
    }
    
    /// Returns a nilable double value from the specified setting.
    /// - Note: If the setting resolves down to a secure string, different handling will occur
    ///         but the returned value will follow the semantics of normal processing.
    /// - Parameter Setting: The setting whose double value will be returned.
    /// - Parameter Default: The default value to return if the stored value is nil. Not returned
    ///                      if the contents of `Default` is nil.
    /// - Returns: The value stored at the specified setting, the contents of `Double` if the stored
    ///            value is nil, nil if `Default` is nil.
    public static func GetDoubleNil(_ Setting: SettingKeys, _ Default: Double? = nil) -> Double?
    {
        /*
        if SecureStringKeyTypes.contains(Setting)
        {
            return SecureStringAsDoubleNil(Setting, Default)
        }
         */
        guard TypeIsValid(Setting, Type: Double?.self) else
        {
            Debug.FatalError("\(Setting) is not a Double?")
        }
        if let Raw = UserDefaults.standard.string(forKey: Setting.rawValue)
        {
            if let Final = Double(Raw)
            {
                return Final
            }
        }
        if let UseDefault = Default
        {
            UserDefaults.standard.set("\(UseDefault)", forKey: Setting.rawValue)
            return UseDefault
        }
        return nil
    }
    
    /// Queries a Double? setting value.
    /// - Parameter Setting: The setting whose Double? value will be passed to the completion handler.
    /// - Parameter Completion: Code to execute after the value is retrieved. The value is passed
    ///                         to the completion handler.
    public static func QueryDoubleNil(_ Setting: SettingKeys, Completion: (Double?) -> Void)
    {
        guard TypeIsValid(Setting, Type: Double?.self) else
        {
            Debug.FatalError("\(Setting) is not a Double?")
        }
        let DoubleNil = GetDoubleNil(Setting)
        Completion(DoubleNil)
    }
    
    /// Save a double value at the specified setting.
    /// - Parameter Setting: The setting where the double value will be stored.
    /// - Parameter Value: The value to save.
    public static func SetDouble(_ Setting: SettingKeys, _ Value: Double)
    {
        guard TypeIsValid(Setting, Type: Double.self) else
        {
            Debug.FatalError("\(Setting) is not a Double")
        }
        let OldValue = UserDefaults.standard.double(forKey: Setting.rawValue)
        let NewValue = Value
        UserDefaults.standard.set(NewValue, forKey: Setting.rawValue)
        NotifySubscribers(Setting: Setting, OldValue: OldValue, NewValue: NewValue)
    }
    
    /// Set the default value for the passed setting key.
    /// - Warning: Throws a fatal error if the key does not point to a `Double`.
    /// - Parameter For: The setting key whose default value will be set.
    public static func SetDoubleDefault(For Key: SettingKeys)
    {
        guard TypeIsValid(Key, Type: Double.self) else
        {
            Debug.FatalError("\(Key) is not a Double")
        }
        if let DefaultValue = Settings.SettingDefaults[Key] as? Double
        {
            SetDouble(Key, DefaultValue)
        }
    }
}
