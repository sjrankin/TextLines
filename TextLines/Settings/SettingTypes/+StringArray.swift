//
//  +StringArray.swift
//  TextLines
//
//  Created by Stuart Rankin on 10/23/21.
//

import Foundation
import UIKit

extension Settings
{
    // MARK: - String array functions.
    
    /// Initialize a string array setting. Subscribers are not notified.
    /// - Parameter Setting: The setting of the string array to initialize.
    /// - Parameter Value: The initial value of the setting.
    public static func InitializeStrings(_ Setting: SettingKeys, _ Value: [String], Delimiter: String = ",")
    {
        let FinalValue = Value.joined(separator: Delimiter)
        UserDefaults.standard.set(FinalValue, forKey: Setting.rawValue)
    }
    
    /// Returns a string array from the specified setting.
    /// - Warning: Throws a fatal error if the type of `Setting` is not `[String]`.
    /// - Parameter Setting: The setting whose string array value will be returned.
    /// - Parameter Delimiter: The delimiter used to split the stored string into the individual components.
    ///                        Defaults to `,` (comma).
    /// - Returns: String array found at the specified setting, or an empty string array if it does not exist.
    public static func GetStrings(_ Setting: SettingKeys, Delimiter: String = ",") -> [String]
    {
        guard TypeIsValid(Setting, Type: [String].self) else
        {
            Debug.FatalError("\(Setting) is not a string array")
        }
        if let Raw = UserDefaults.standard.string(forKey: Setting.rawValue)
        {
            let Parts = Raw.components(separatedBy: Delimiter)
            return Parts
        }
        return [String]()
    }
    
    /// Returns a string array from the specified setting.
    /// - Warning: Throws a fatal error if the type of `Setting` is not `[String]`.
    /// - Parameter Setting: The setting whose string array value will be returned.
    /// - Parameter Delimiter: The delimiter used to split the stored string into the individual components.
    ///                        Defaults to `,` (comma).
    /// - Returns: String array found at the specified setting. If the value at the specified setting is
    ///            empty or nil, the contents of `Default` are returned.
    public static func GetStrings(_ Setting: SettingKeys, Delimiter: String = ",",
                                  Default: [String]) -> [String]
    {
        guard TypeIsValid(Setting, Type: [String].self) else
        {
            Debug.FatalError("\(Setting) is not a string array")
        }
        if let Raw = UserDefaults.standard.string(forKey: Setting.rawValue)
        {
            let Parts = Raw.components(separatedBy: Delimiter)
            return Parts
        }
        return Default
    }
    
    /// Save a string array at the specified setting.
    /// - Parameter Setting: The setting where the string value will be saved.
    /// - Parameter Values: The array of strings to save.
    /// - Parameter Delimiter: The delimiter used to combine the stored string into the individual components.
    ///                        Defaults to `,` (comma).
    public static func SetStrings(_ Setting: SettingKeys, _ Values: [String], Delimiter: String = ",")
    {
        guard TypeIsValid(Setting, Type: [String].self) else
        {
            Debug.FatalError("\(Setting) is not a string array")
        }
        let FinalValue = Values.joined(separator: Delimiter)
        UserDefaults.standard.set(FinalValue, forKey: Setting.rawValue)
        NotifySubscribers(Setting: Setting, OldValue: nil, NewValue: nil)
    }
}
