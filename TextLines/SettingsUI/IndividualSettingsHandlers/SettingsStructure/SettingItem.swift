//
//  SettingItem.swift
//  SettingItem
//
//  Created by Stuart Rankin on 8/16/21.
//

import Foundation
import UIKit

typealias DoubleConverter = (Double) -> (Double)
typealias CGFloatConverter = (CGFloat) -> (CGFloat)

class SettingItem
{
    init(For Setting: SettingKeys)
    {
        SettingKey = Setting
    }
    
    func GenerateCell(With Width: CGFloat) -> UITableViewCell?
    {
        return SettingItem.GenerateCell(Header: Header, With: Width, SettingKey: SettingKey,
                                        DoubleVisible: ToVisibleConverter,
                                        DoubleSave: ToFinalConverter,
                                        CGFloatVisible: ToCGVisibleConverter,
                                        CGFloatSave: ToFinalCGConverter)
    }
    
    public static func GenerateCell(Header: String, With Width: CGFloat,
                                    SettingKey: SettingKeys,
                                    DoubleVisible: DoubleConverter? = nil,
                                    DoubleSave: DoubleConverter? = nil,
                                    CGFloatVisible: CGFloatConverter? = nil,
                                    CGFloatSave: CGFloatConverter? = nil) -> UITableViewCell?
    {
        if let SettingType = Settings.SettingKeyTypes[SettingKey]
        {
            let TypeName = "\(SettingType)"
            switch TypeName
            {
                case "Bool":
                    let Cell = BooleanCell(style: .default, reuseIdentifier: "BooleanCell")
                    Cell.LoadCell(Setting: SettingKey,
                                   Header: Header, Width: Width)
                    return Cell
                    
                case "Int":
                    let Cell = IntCell(style: .default, reuseIdentifier: "IntCell")
                    Cell.LoadCell(Setting: SettingKey,
                                   Header: Header,  Width: Width)
                    return Cell
                    
                case "Double":
                    let Cell = DoubleCell(style: .default, reuseIdentifier: "DoubleCell")
                    Cell.ForInput = DoubleVisible
                    Cell.ForOutput = DoubleSave
                    Cell.LoadCell(Setting: SettingKey,
                                   Header: Header,  Width: Width)
                    return Cell
                    
                case "CGFloat":
                    let Cell = CGFloatCell(style: .default, reuseIdentifier: "CGFloatCell")
                    Cell.ForInput = CGFloatVisible
                    Cell.ForOutput = CGFloatSave
                    Cell.LoadCell(Setting: SettingKey,
                                  Header: Header, Width: Width)
                    return Cell
                    
                case "String":
                    let Cell = StringCell(style: .default, reuseIdentifier: "StringCell")
                    Cell.LoadCell(Setting: SettingKey, Header: Header,
                                  Width: Width)
                    return Cell
                    
                case "UIColor":
                    let Cell = ColorCell(style: .default, reuseIdentifier: "ColorCell")
                    Cell.LoadCell(Setting: SettingKey, Header: Header,
                                  Width: Width)
                    return Cell
                    
                case "UUID":
                    let Cell = UUIDCell(style: .default, reuseIdentifier: "StringCell")
                    Cell.LoadCell(Setting: SettingKey, Header: Header,
                                  Width: Width)
                    return Cell
                    
                case "ShapeCategories", "Shapes", "Backgrounds", "ShapeAlignments",
                    "LineOptions", "LineStyles":
                    let Cell = EnumCell(style: .default, reuseIdentifier: "StringCell")
                    Cell.LoadCell(Setting: SettingKey, Header: Header,
                                  Width: Width)
                    return Cell
                    
                default:
                    //Crashes the program if an uncomprehended type is encountered.
                    Debug.FatalError("Uncomprehended type (\(TypeName)) found.")
            }
        }
        return nil
    }
    
    var SettingType: String?
    {
        get
        {
            if let SType = Settings.SettingKeyTypes[SettingKey]
            {
                return "\(SType)"
            }
            return nil
        }
    }
    
    func SetDoubleToVisible(_ ToVisible: DoubleConverter? = nil)
    {
        ToVisibleConverter = ToVisible
    }
    
    var ToVisibleConverter: DoubleConverter? = nil
    
    func SetDoubleToFinal(_ ToFinal: DoubleConverter? = nil)
    {
        ToFinalConverter = ToFinal
    }
    
    var ToCGVisibleConverter: CGFloatConverter? = nil
    
    func SetCGFloatToFinal(_ ToFinal: CGFloatConverter? = nil)
    {
        ToCGVisibleConverter = ToFinal
    }
    
    var ToFinalConverter: DoubleConverter? = nil
    
    var ToFinalCGConverter: CGFloatConverter? = nil
    
    var SettingKey: SettingKeys = .CircleDiameter
    var Header: String = "Setting header"
    var SubHeader: String = ""
}

