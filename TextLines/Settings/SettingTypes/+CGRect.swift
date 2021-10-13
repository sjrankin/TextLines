//
//  +CGRect.swift
//  +CGRect
//
//  Created by Stuart Rankin on 7/19/21. Adapted from Flatland View.
//

import Foundation
import UIKit

extension Settings
{
    // MARK: - CGRect functions.
    
    /// Encode an `CGRect` into a string for saving into user defaults.
    /// - Parameter Rect: The `CGRect` to encode.
    /// - Returns: String with the passed `CGRect` encoded.
    private static func EncodeRect(_ Rect: CGRect) -> String
    {
        return "\(Rect.origin.x),\(Rect.origin.y),\(Rect.size.width),\(Rect.size.height)"
    }
    
    /// Decode an encoded `CGRect`.
    /// - Parameter Encoded: The encoded `CGRect` to decode.
    /// - Returns: `CGRect` populated with the values in `Encoded` on success, nil on error (badly
    ///            encoded data or incorrect data format).
    private static func DecodeRect(_ Encoded: String) -> CGRect?
    {
        let Parts = Encoded.split(separator: ",", omittingEmptySubsequences: true)
        if Parts.count != 4
        {
            return nil
        }
        let OX = Double(String(Parts[0]))
        let OY = Double(String(Parts[1]))
        let SW = Double(String(Parts[2]))
        let SH = Double(String(Parts[3]))
        if OX == nil || OY == nil || SW == nil || SH == nil
        {
            return nil
        }
        return CGRect(origin: CGPoint(x: OX!, y: OY!), size: CGSize(width: SW!, height: SH!))
    }
    
    /// Initialize an `CGRect` setting. Subscribers are not notified.
    /// - Parameter Setting: The setting where the `CGRect` will be stored.
    /// - Parameter Value: The `CGRect` to save.
    public static func InitializeRect(_ Setting: SettingKeys, _ Value: CGRect)
    {
        let Encoded = EncodeRect(Value)
        UserDefaults.standard.set(Encoded, forKey: Setting.rawValue)
    }
    
    /// Save the value of an `CGRect` to user settings.
    /// - Parameter Setting: The setting where the `CGRect` will be stored.
    /// - Parameter Value: The value to store.
    public static func SetRect(_ Setting: SettingKeys, _ Value: CGRect)
    {
        guard TypeIsValid(Setting, Type: CGRect.self) else
        {
            Debug.FatalError("\(Setting) is not a CGRect")
        }
        let OldValue = GetRect(Setting)
        let Encoded = EncodeRect(Value)
        UserDefaults.standard.set(Encoded, forKey: Setting.rawValue)
        NotifySubscribers(Setting: Setting, OldValue: OldValue, NewValue: Encoded)
    }
    
    /// Returns an `CGRect` saved in user settings.
    /// - Parameter Setting: The location of the saved `CGRect`.
    /// - Returns: Populated `CGRect` on success, nil on error.
    public static func GetRect(_ Setting: SettingKeys) -> CGRect?
    {
        guard TypeIsValid(Setting, Type: CGRect.self) else
        {
            Debug.FatalError("\(Setting) is not a CGRect")
        }
        if let Value = UserDefaults.standard.string(forKey: Setting.rawValue)
        {
            return DecodeRect(Value)
        }
        else
        {
            return nil
        }
    }
    
    /// Returns an `CGRect` saved in user settings.
    /// - Note: If there is no value at the specified settings, the value in `Default` will be returned
    ///         if it is not nil. If it is not nil, the value in `Default` will also be written to
    ///         `Setting`.
    /// - Parameter Setting: The location of the saved `CGRect`.
    /// - Parameter Default: If present the default value to return if `Setting` does not yet have
    ///                      a value.
    /// - Returns: The value found in `Setting` if it exists, the value found in `Default` if
    ///            `Setting` is empty, `CGRect.zero` if `Default` is nil.
    public static func GetRect(_ Setting: SettingKeys, Default: CGRect? = nil) -> CGRect
    {
        guard TypeIsValid(Setting, Type: CGRect.self) else
        {
            Debug.FatalError("\(Setting) is not a CGRect")
        }
        if let Value = UserDefaults.standard.string(forKey: Setting.rawValue)
        {
            if let Actual = DecodeRect(Value)
            {
                return Actual
            }
        }
        
        if let SaveMe = Default
        {
            SetRect(Setting, SaveMe)
            return SaveMe
        }
        
        return CGRect.zero
    }
}
