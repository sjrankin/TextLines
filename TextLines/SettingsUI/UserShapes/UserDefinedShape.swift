//
//  UserDefinedShape.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/30/21.
//

import Foundation
import UIKit

/// Encapsulates a single user-defined shape.
class UserDefinedShape
{
    /// Holds the name of the shape.
    private var _Name: String = ""
    {
        didSet
        {
            _IsDirty = true
        }
    }
    /// Get or set the name of the shape.
    public var Name: String
    {
        get
        {
            return _Name
        }
        set
        {
            _Name = newValue
        }
    }
    
    /// Holds the ID of the shape.
    private var _ID: UUID = UUID()
    {
        didSet
        {
            _IsDirty = true
        }
    }
    /// Get or set the ID of the shape.
    /// - Note: Changing the ID will cause the user shape manager
    ///         to think this is a new shape.
    public var ID: UUID
    {
        get
        {
            return _ID
        }
        set
        {
            _ID = newValue
        }
    }
    
    /// Holds the smooth lines flag.
    private var _SmoothLines: Bool = false
    {
        didSet
        {
            _IsDirty = true
        }
    }
    /// Get or set the smooth lines flag.
    public var SmoothLines: Bool
    {
        get
        {
            return _SmoothLines
        }
        set
        {
            _SmoothLines = newValue
        }
    }
    
    /// Holds the closed shape flag.
    private var _ClosedLoop: Bool = true
    {
        didSet
        {
            _IsDirty = true
        }
    }
    /// Get or set the closed shape flag.
    public var ClosedLoop: Bool
    {
        get
        {
            return _ClosedLoop
        }
        set
        {
            _ClosedLoop = newValue
        }
    }
    
    /// Holds the predefined flag.
    private var _Predefined: Bool = false
    /// Get the predefined flag. If true, the shape was predefined at compile time and cannot
    /// be deleted or edited (but can be saved, then edited). If false, the shape was defined by the user can be deleted.
    public var Predefined: Bool
    {
        get
        {
            return _Predefined
        }
    }
    
    /// Holds the set of points that defines the shape.
    private var _Points: [CGPoint] = [CGPoint]()
    {
        didSet
        {
            _IsDirty = true
        }
    }
    /// Get or set the set of points that defines the shape.
    public var Points: [CGPoint]
    {
        get
        {
            return _Points
        }
        set
        {
            _Points = newValue
        }
    }
    
    /// Holds the viewport width.
    private var _ViewportWidth: Int = 1000
    {
        didSet
        {
            _IsDirty = true
        }
    }
    /// Get or set the viewport width.
    public var ViewportWidth: Int
    {
        get
        {
            return _ViewportWidth
        }
        set
        {
            _ViewportWidth = newValue
        }
    }
    
    /// Holds the viewport height.
    private var _ViewportHeight: Int = 1000
    {
        didSet
        {
            _IsDirty = true
        }
    }
    /// Get or set the viewport height.
    public var ViewportHeight: Int
    {
        get
        {
            return _ViewportHeight
        }
        set
        {
            _ViewportHeight = newValue
        }
    }
    
    // Calculated at runtime and not saved.
    public var SmoothedPath: [CGPoint] = [CGPoint]()
    
    // Saved when setting initial data.
    public var RawSource: String = ""
    
    /// Holds the dirty flag.
    private var _IsDirty: Bool = false
    
    /// Get the dirty flag.
    public var IsDirty: Bool
    {
        get
        {
            return _IsDirty
        }
    }
    
    /// Returns the current `UIBezierPath` of the shape. An empty `UIBezierPath` is returned
    /// on error.
    public func Path() -> UIBezierPath
    {
        var PointsToDisplay = Points
        if SmoothLines
        {
            PointsToDisplay = Chaikin.SmoothPoints(Points: PointsToDisplay,
                                                   Iterations: 5,
                                                   Closed: ClosedLoop)
        }
        let Generated = UserShape.GenerateShape(PointsToDisplay,
                                                ShowPoints: false,
                                                ClosePath: ClosedLoop,
                                                MainLineWidth: 2.0,
                                                MainLineColor: UIColor.red,
                                                Scale: nil)
        return Generated
    }
    
    /// Deserialize a stored string into proper fields.
    /// - Parameter Raw: The raw, saved string of the data for the shape.
    func ParseRawPath(_ Raw: String)
    {
        RawSource = Raw
        let Separator = String.Element("ƒ")
        let Parts = Raw.split(separator: Separator, omittingEmptySubsequences: true)
        for Part in Parts
        {
            let Working = String(Part)
            let Records = Working.split(separator: "=", omittingEmptySubsequences: true)
            if Records.count != 2
            {
                Debug.FatalError("Unexpected number (\(Records.count)) of KVPs found in raw data: \(String(Records[0]))")
            }

            switch String(Records[0])
            {
                case "Name":
                    Name = String(Records[1])
                    
                case "ID":
                    ID = UUID(uuidString: String(Records[1]))!
                    
                case "Smooth":
                    SmoothLines = Bool(String(Records[1]))!
                    
                case "Closed":
                    ClosedLoop = Bool(String(Records[1]))!
                    
                case "Predefined":
                    _Predefined = Bool(String(Records[1]))!
                    
                case "Viewport":
                    let VPSize = String(Records[1]).split(separator: "x", omittingEmptySubsequences: true)
                    if VPSize.count != 2
                    {
                    break
                    }
                    guard let Width = Int(String(VPSize[0])) else
                    {
                        break
                    }
                    guard let Height = Int(String(VPSize[1])) else
                    {
                        break
                    }
                    ViewportWidth = Width
                    ViewportHeight = Height
                    
                case "Points":
                    let PointParts = String(Records[1]).split(separator: ",", omittingEmptySubsequences: true)
                    for PointPart in PointParts
                    {
                        let PData = String(PointPart).split(separator: ";", omittingEmptySubsequences: true)
                        if PData.count != 2
                        {
                            Debug.FatalError("Invalid point structure: \(PointPart)")
                        }
                        let RawX = String(PData[0])
                        let RawY = String(PData[1])
                        guard let X = Double(String(RawX)) else
                        {
                            Debug.FatalError("Error converting \(RawX) to X.")
                        }
                        guard let Y = Double(String(RawY)) else
                        {
                            Debug.FatalError("Error converting \(RawY) to Y.")
                        }
                        let NewPoint = CGPoint(x: X, y: Y)
                        Points.append(NewPoint)
                    }
                    
                default:
                    break
            }
        }
        //Last must reset the dirty flag
        _IsDirty = false
    }
    
    /// Returns a serialized string with the data in the class.
    /// - Note: Smoothed points are *not* included.
    /// - Returns: String with serialized class data.
    func CreateSaveableUserPath() -> String
    {
        if !IsDirty
        {
            return RawSource
        }
        var Saveable = ""
        Saveable.append("Name=\(Name)ƒ")
        Saveable.append("ID=\(ID.uuidString)ƒ")
        Saveable.append("Smooth=\(SmoothLines)ƒ")
        Saveable.append("Closed=\(ClosedLoop)ƒ")
        Saveable.append("Predefined=\(Predefined)ƒ")
        Saveable.append("Viewport=\(ViewportWidth)x\(ViewportHeight)ƒ")
        Saveable.append("Points=")
        for Point in Points
        {
            Saveable.append("\(Point.x);\(Point.y),")
        }
        return Saveable
    }
}
