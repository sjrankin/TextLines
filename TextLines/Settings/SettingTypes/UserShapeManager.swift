//
//  UserShapeManager.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/30/21.
//

import Foundation
import UIKit

/// Manages user shapes stored in user settings.
class UserShapeManager
{
    private static var Initialized: Bool = false
    static let DataSeparator = String.Element("ı")
    
    /// Load user shapes from user settings.
    public static func LoadUserShapes()
    {
        if Initialized
        {
            return
        }
        Initialized = true
        UserShapeList.removeAll()
        let RawData = Settings.GetString(.UserShapes, "")
        let Parts = RawData.split(separator: DataSeparator, omittingEmptySubsequences: true)
        for Part in Parts
        {
            let NewShape = UserDefinedShape()
            NewShape.ParseRawPath(String(Part))
            UserShapeList.append(NewShape)
        }
    }
    
    /// Save user shapes to user settings.
    public static func SaveUserShapes()
    {
        var Result = ""
        for SomeShape in UserShapeList
        {
            let Serialized = SomeShape.CreateSaveableUserPath()
            Result.append(Serialized)
            Result.append(DataSeparator)
        }
        Settings.SetString(.UserShapes, Result)
    }
    
    /// Remove the shape with the passed ID.
    /// - Parameter With: The ID of the shape to remove. If the ID does not exist,
    ///                   no action will be taken.
    /// - Parameter AndSave: If true, the updated `UserShapeList` will be saved.
    public static func RemoveShape(With ID: UUID, AndSave: Bool = true)
    {
        guard let Index = IndexOfShape(With: ID) else
        {
            Debug.Print("Unable to find shape with ID \(ID.uuidString)")
            return
        }
        UserShapeList.remove(at: Index)
        if AndSave
        {
            SaveUserShapes()
        }
    }
    
    /// Swap two items in the user shape list.
    /// - Parameter Index1: Index of the first item to swap.
    /// - Parameter Index2: Index of the second item to swap.
    public static func SwapShapes(Index1: Int, Index2: Int)
    {
        print("Shape list:")
        for someshape in UserShapeList
        {
            print("  \(someshape.Name)")
        }
        if Index1 < 0 || Index2 < 0
        {
            Debug.FatalError("Invalid indices (\(Index1)),(\(Index2)) in SwapShapes")
        }
        if Index1 > UserShapeList.count - 1 && Index2 > UserShapeList.count - 1
        {
            Debug.FatalError("Invalid indices (\(Index1)),(\(Index2)) in SwapShapes [Count=\(UserShapeList.count)]")
        }
        UserShapeList.swapAt(Index1, Index2)
        print("Shape list:")
        for someshape in UserShapeList
        {
            print("  \(someshape.Name)")
        }
    }
    
    /// Update or add the passed shape to the user defined shape list.
    /// - Parameter Update: The shape to update or add. If the shape does not exist in
    ///                     the UserDefinedShape array, it will be added. Otherwise, the
    ///                     old shape will be overwritten with the passed shape.
    /// - Parameter AndSave: If true, the user defined shape list will be saved after it is
    ///                      updated.
    public static func UpdateShape(Updated Shape: UserDefinedShape, AndSave: Bool = true)
    {
        if let Index = IndexOfShape(With: Shape.ID)
        {
            UserShapeList[Index] = Shape
        }
        else
        {
            UserShapeList.append(Shape)
        }
        
        if AndSave
        {
            SaveUserShapes()
        }
    }
    
    /// Return the user defined shape with the passed ID.
    /// - Parameter With: The ID of the shape to return.
    /// - Returns: The specified user defined shape if found, nil if it is not found.
    public static func GetShape(With ID: UUID) -> UserDefinedShape?
    {
        if let Index = IndexOfShape(With: ID)
        {
            return UserShapeList[Index]
        }
        return nil
    }
    
    /// Detects if any user shape in the user shape array has the specified ID.
    /// - Parameter ID: The ID to search for.
    /// - Returns: True if the passed ID was found, false if not.
    public static func HasShape(ID: UUID) -> Bool
    {
        if let _ = IndexOfShape(With: ID)
        {
            return true
        }
        return false
    }
    
    /// Returns the index of the shape whose ID is passed.
    /// - Important: The value returned (if not nil) is valid only as long as no
    ///              additions or subtractions are done to `UserShapeList`.
    /// - Parameter With: The ID of the shape whose index will be returned.
    /// - Returns: The index into the `UserShapeList` of the ID of the user defined
    ///            shape. Nil if not found.
    public static func IndexOfShape(With ID: UUID) -> Int?
    {
        for Index in 0 ..< UserShapeList.count
        {
            if UserShapeList[Index].ID == ID
            {
                return Index
            }
        }
        return nil
    }
    
    /// Returns the current count of the number of user shapes being managed.
    /// - Returns: Number of user shapes being managed.
    public static var Count: Int
    {
        get
        {
            return UserShapeList.count
        }
    }
    
    /// Holds all of the loaded user shapes.
    public static var UserShapeList = [UserDefinedShape]()
}

