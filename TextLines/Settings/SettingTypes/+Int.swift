//
//  +Int.swift
//  +Int
//
//  Created by Stuart Rankin on 7/19/21.
//

import Foundation
import UIKit

extension Settings
{
    // MARK: - Int functions.
    
    /// Initialize an Integer setting. Subscribers are not notified.
    /// - Warning: A fatal error will be thrown if the type of `Setting` is not Int.
    /// - Parameter Setting: The setting of the integer to initialize.
    /// - Parameter Value: The initial value of the setting.
    public static func InitializeInt(_ Setting: SettingKeys, _ Value: Int)
    {
        guard TypeIsValid(Setting, Type: Int.self) else
        {
            Debug.FatalError("\(Setting) is not an Int")
        }
        UserDefaults.standard.set(Value, forKey: Setting.rawValue)
    }
    
    /// Returns an integer from the specified setting.
    /// - Warning: A fatal error will be thrown if the type of `Setting` is not Int.
    /// - Parameter Setting: The setting whose integer value will be returned.
    /// - Returns: Integer found at the specified setting.
    public static func GetInt(_ Setting: SettingKeys) -> Int
    {
        guard TypeIsValid(Setting, Type: Int.self) else
        {
            Debug.FatalError("\(Setting) is not an Int")
        }
        return UserDefaults.standard.integer(forKey: Setting.rawValue)
    }
    
    /// Returns an integer from the specified setting.
    /// - Warning: A fatal error will be thrown if the type of `Setting` is not Int.
    /// - Parameter Setting: The setting whose integer value will be returned.
    /// - Parameter IfZero: The value to return if the value in the setting is zero. If the value in the
    ///                     setting is zero, the value of `IfZero` is saved there.
    /// - Returns: Integer found at the specified setting. If that value is `0`, the value passed in `IfZero`
    ///            is saved in the setting then returned.
    public static func GetInt(_ Setting: SettingKeys, IfZero: Int) -> Int
    {
        guard TypeIsValid(Setting, Type: Int.self) else
        {
            Debug.FatalError("\(Setting) is not an Int")
        }
        let Value = UserDefaults.standard.integer(forKey: Setting.rawValue)
        if Value == 0
        {
            UserDefaults.standard.setValue(IfZero, forKey: Setting.rawValue)
            return IfZero
        }
        return Value
    }
    
    /// Returns an integer from the specified setting but as a `Double` type.
    /// - Warning: A fatal error will be thrown if the type of `Setting` is not Int.
    /// - Parameter Setting: The setting whose integer value will be returned.
    /// - Returns: The integer value found at the specified setting cast to a `Double`.
    public static func GetIntAsDouble(_ Setting: SettingKeys) -> Double
    {
        guard TypeIsValid(Setting, Type: Int.self) else
        {
            Debug.FatalError("\(Setting) is not an Int")
        }
        let Value = UserDefaults.standard.integer(forKey: Setting.rawValue)
        return Double(Value)
    }
    
    /// Queries an integer setting value.
    /// - Warning: A fatal error will be thrown if the type of `Setting` is not Int.
    /// - Parameter Setting: The setting whose integer value will be passed to the completion handler.
    /// - Parameter Completion: Code to execute after the value is retrieved. The value is passed
    ///                         to the completion handler.
    public static func QueryInt(_ Setting: SettingKeys, Completion: (Int) -> Void)
    {
        guard TypeIsValid(Setting, Type: Int.self) else
        {
            Debug.FatalError("\(Setting) is not an Int")
        }
        let IntValue = UserDefaults.standard.integer(forKey: Setting.rawValue)
        Completion(IntValue)
    }
    
    /// Save an integer at the specified setting.
    /// - Warning: A fatal error will be thrown if the type of `Setting` is not Int.
    /// - Parameter Setting: The setting where the integer value will be saved.
    /// - Parameter Value: The value to save.
    public static func SetInt(_ Setting: SettingKeys, _ Value: Int)
    {
        guard TypeIsValid(Setting, Type: Int.self) else
        {
            Debug.FatalError("\(Setting) is not an Int")
        }
        let OldValue = UserDefaults.standard.integer(forKey: Setting.rawValue)
        let NewValue = Value
        UserDefaults.standard.set(NewValue, forKey: Setting.rawValue)
        NotifySubscribers(Setting: Setting, OldValue: OldValue, NewValue: NewValue)
    }
    
    /// Increment an integer value at the passed setting.
    /// - Warning: A fatal error will be thrown if the type of `Setting` is not Int.
    /// - Parameter Setting: The setting whose value will be incremented.
    /// - Returns: Incremented value.
    @discardableResult public static func IncrementInt(_ Setting: SettingKeys) -> Int
    {
        guard TypeIsValid(Setting, Type: Int.self) else
        {
            Debug.FatalError("\(Setting) is not an Int")
        }
        var OldValue = UserDefaults.standard.integer(forKey: Setting.rawValue)
        OldValue = OldValue + 1
        UserDefaults.standard.set(OldValue, forKey: Setting.rawValue)
        return OldValue
    }
}
