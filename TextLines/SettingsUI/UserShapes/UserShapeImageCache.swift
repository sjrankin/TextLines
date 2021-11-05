//
//  UserShapeImageCache.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/4/21.
//

import Foundation
import UIKit

/// In memory cache for user shape thumbnails. Each user shape has two thumbnails -
/// one for normal display and one for highlighted display.
/// - Note: Easy to expand to use persistent memory. However, persistent images may
///         lead to synchronization issues if the app crashes which would require extra
///         code to clean things up every start-up.
class UserShapeImageCache
{
    /// Determines if the cache has images for the passed ID.
    /// - Parameter ID: The ID to look for.
    /// - Returns: True if the cache contains the specified ID, false if not.
    static func HasCachedImageSet(ID: UUID) -> Bool
    {
        return LocalCache.keys.contains(ID)
    }
    
    /// Return the set of images for the passed ID.
    /// - Parameter ID: The ID of the images to return.
    /// - Returns: Tuple of a normal image and a highlighted image if present,
    ///            nil if not found.
    static func GetCachedImageSet(ID: UUID) -> (Normal: UIImage, Highlighted: UIImage)?
    {
        if HasCachedImageSet(ID: ID)
        {
            return LocalCache[ID]
        }
        return nil
    }
    
    /// Save images for the passed ID in the cache.
    /// - Parameter ID: The ID of the images.
    /// - Parameter Normal: The "normal," unhighlighted image.
    /// - Parameter Highlighted: The "highlighted" image.
    static func SaveInCache(ID: UUID, Normal: UIImage, Highlighted: UIImage)
    {
        LocalCache[ID] = (Normal, Highlighted)
    }
    
    /// Remove the images with the specified ID from the cache.
    /// - Parameter ID: The ID of the images to remove. If the ID is not in the
    ///                 cache, no action is taken.
    static func RemoveFromCache(ID: UUID)
    {
        if HasCachedImageSet(ID: ID)
        {
            LocalCache.removeValue(forKey: ID)
        }
    }
    
    /// Remove all images from the cache.
    static func ClearCache()
    {
        LocalCache.removeAll()
    }
    
    /// Contains cached images for user shape thumbnails.
    static var LocalCache = [UUID: (Normal: UIImage, Highlighted: UIImage)]()
}
