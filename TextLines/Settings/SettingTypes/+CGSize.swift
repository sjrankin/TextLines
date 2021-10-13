//
//  +CGSize.swift
//  +CGSize
//
//  Created by Stuart Rankin on 7/19/21. Adapted from Flatland View
//

import Foundation
import UIKit

extension Settings
{
    // MARK: - CGSize functions.
    
    /// Set an CGSize value.
    /// - Warming: A fatal error will be thrown if the type of `Setting` is not `CGSize`.
    /// - Parameter Setting: The setting where the value will be saved.
    /// - Parameter Value: The value to save.
    public static func SetCGSize(_ Setting: SettingKeys, _ Value: CGSize)
    {
        guard TypeIsValid(Setting, Type: CGSize.self) else
        {
            Debug.FatalError("\(Setting) is not an CGSize")
        }
        let Serialized = "\(Value.width),\(Value.height)"
        let OldValue = GetCGSize(Setting)
        UserDefaults.standard.set(Serialized, forKey: Setting.rawValue)
        NotifySubscribers(Setting: Setting, OldValue: OldValue, NewValue: Value)
    }
    
    /// Get the CGSize value at the specified setting.
    /// - Warming: A fatal error will be thrown if the type of `Setting` is not `CGSize`.
    /// - Parameter Setting: The setting where the CGSize value is stored.
    /// - Parameter Default: If there is no value in `Setting` and `Default` has a value, the value in
    ///                      `Default` will be returned.
    /// - Returns: The CGSize value on success, nil if not available.
    public static func GetCGSize(_ Setting: SettingKeys, Default: CGSize? = nil) -> CGSize?
    {
        guard TypeIsValid(Setting, Type: CGSize.self) else
        {
            Debug.FatalError("\(Setting) is not an CGSize")
        }
        if let Raw = UserDefaults.standard.string(forKey: Setting.rawValue)
        {
            let Parts = Raw.split(separator: ",", omittingEmptySubsequences: true)
            guard Parts.count == 2 else
            {
                Debug.FatalError("Mal-formed CGSize found for \(Setting.rawValue): \"\(Raw)\"")
            }
            guard let Width = Double(String(Parts[0])) else
            {
                Debug.FatalError("Error parsing value from \(Setting.rawValue): \"\(Raw)\"")
            }
            guard let Height = Double(String(Parts[1])) else
            {
                Debug.FatalError("Error parsing value from \(Setting.rawValue): \"\(Raw)\"")
            }
            return CGSize(width: Width, height: Height)
        }
        else
        {
            if let DefaultValue = Default
            {
                let Serialized = "\(DefaultValue.width),\(DefaultValue.height)"
                UserDefaults.standard.set(Serialized, forKey: Setting.rawValue)
                return Default
            }
            else
            {
                return nil
            }
        }
    }
    
    /// Get the CGSize value at the specified setting.
    /// - Warming: A fatal error will be thrown if the type of `Setting` is not `CGSize`.
    /// - Parameter Setting: The setting where the CGSize value is stored.
    /// - Parameter Default: If there is no value in `Setting` and `Default` has a value, the value in
    ///                      `Default` will be returned.
    /// - Returns: The CGSize value on success, value of `Default` if not available.
    public static func GetCGSize(_ Setting: SettingKeys, Default: CGSize) -> CGSize
    {
        guard TypeIsValid(Setting, Type: CGSize.self) else
        {
            Debug.FatalError("\(Setting) is not an CGSize")
        }
        if let Raw = UserDefaults.standard.string(forKey: Setting.rawValue)
        {
            let Parts = Raw.split(separator: ",", omittingEmptySubsequences: true)
            guard Parts.count == 2 else
            {
                Debug.FatalError("Mal-formed CGSize found for \(Setting.rawValue): \"\(Raw)\"")
            }
            guard let Width = Double(String(Parts[0])) else
            {
                Debug.FatalError("Error parsing value from \(Setting.rawValue): \"\(Raw)\"")
            }
            guard let Height = Double(String(Parts[1])) else
            {
                Debug.FatalError("Error parsing value from \(Setting.rawValue): \"\(Raw)\"")
            }
            return CGSize(width: Width, height: Height)
        }
        return Default
    }
}
