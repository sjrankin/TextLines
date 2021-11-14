//
//  +IndividualShapeSettings.swift
//  +IndividualShapeSettings
//
//  Created by Stuart Rankin on 8/29/21.
//

import Foundation
import UIKit

extension IndividualShapes: UITableViewDelegate, UITableViewDataSource
{
    func SetOptionsFor(_ Shape: Shapes)
    {
        OptionsList.removeAll()
        SettingTable.reloadData()
        
        switch Shape
        {
            case .Circle:
                CurrentShapeOptions = OptionItem(.Circle)
                let Item1 = SettingItem(For: .CircleDiameter)
                Item1.Header = "Diameter of circle"
                
                let Item2 = SettingItem(For: .CircleAngle)
                Item2.Header = "Text starting angle"
                Item2.ToFinalConverter =
                {
                    DValue in
                    return DValue.Radians
                }
                Item2.ToVisibleConverter =
                {
                    DValue in
                    return DValue.Degrees
                }
                
                let Item = OptionItem(.Circle)
                Item.SettingItemList.append(Item1)
                Item.SettingItemList.append(Item2)
                
                CurrentShapeOptions = Item
                
            case .Ellipse:
                CurrentShapeOptions = OptionItem(.Ellipse)
                let Item1 = SettingItem(For: .EllipseMajor)
                Item1.Header = "Width of ellipse"
                
                let Item2 = SettingItem(For: .EllipseMinor)
                Item2.Header = "Height of  ellipse"
                
                let Item3 = SettingItem(For: .EllipseAngle)
                Item3.Header = "Text starting angle"
                Item3.ToFinalConverter =
                {
                    DValue in
                    return DValue.Radians
                }
                Item3.ToVisibleConverter =
                {
                    DValue in
                    return DValue.Degrees
                }
                
                let Item = OptionItem(.Ellipse)
                Item.SettingItemList.append(Item1)
                Item.SettingItemList.append(Item2)
                Item.SettingItemList.append(Item3)
                
                CurrentShapeOptions = Item
                
            case .Rectangle:
                CurrentShapeOptions = OptionItem(.Rectangle)
                let Item1 = SettingItem(For: .RectangleWidth)
                Item1.Header = "Rectangle width"
                
                let Item2 = SettingItem(For: .RectangleHeight)
                Item2.Header = "Rectangle height"
                
                let Item3 = SettingItem(For: .RectangleRoundedCorners)
                Item3.Header = "Has rounded corners"
                
                let Item = OptionItem(.Rectangle)
                Item.SettingItemList.append(Item1)
                Item.SettingItemList.append(Item2)
                Item.SettingItemList.append(Item3)
                
                CurrentShapeOptions = Item
                
            case .Triangle:
                CurrentShapeOptions = OptionItem(.Triangle)
                let Item1 = SettingItem(For: .TriangleBase)
                Item1.Header = "Triangle base"
                
                let Item2 = SettingItem(For: .TriangleHeight)
                Item2.Header = "Triangle height"
                
                let Item3 = SettingItem(For: .TriangleRounded)
                Item3.Header = "Rounded vertices"
                
                let Item = OptionItem(.Triangle)
                Item.SettingItemList.append(Item1)
                Item.SettingItemList.append(Item2)
                Item.SettingItemList.append(Item3)
                
                CurrentShapeOptions = Item
                
            case .Line:
                CurrentShapeOptions = OptionItem(.Line)
                let Item1 = SettingItem(For: .LineLength)
                Item1.Header = "Length"
                
                let Item2 = SettingItem(For: .LineType)
                Item2.Header = "Orientation"
                
                let Item = OptionItem(.Line)
                Item.SettingItemList.append(Item1)
                Item.SettingItemList.append(Item2)
                
                CurrentShapeOptions = Item
                
            case .Spiral:
                CurrentShapeOptions = OptionItem(.Spiral)
                
                let Item1 = SettingItem(For: .SpiralStartRadius)
                Item1.Header = "Start radius"
                
                let Item2 = SettingItem(For: .SpiralSpacePerLoop)
                Item2.Header = "Spiral gap"
                
                let Item3 = SettingItem(For: .SpiralStartTheta)
                Item3.Header = "Starting theta"
                
                let Item4 = SettingItem(For: .SpiralEndTheta)
                Item4.Header = "Ending theta"
                
                let Item5 = SettingItem(For: .SpiralThetaStep)
                Item5.Header = "Theta step"
                
                let Item = OptionItem(.Spiral)
                Item.SettingItemList.append(Item1)
                Item.SettingItemList.append(Item2)
                Item.SettingItemList.append(Item3)
                Item.SettingItemList.append(Item4)
                Item.SettingItemList.append(Item5)
                
                CurrentShapeOptions = Item
                
            default:
                return
        }
        
        SettingTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        guard let RowKey = CurrentShapeOptions?.SettingItemList[indexPath.row].SettingKey else
        {
            return 0
        }
        guard let KeyType = Settings.SettingKeyTypes[RowKey] else
        {
            return 0
        }
        let KeyTypeName = "\(KeyType)"
        switch KeyTypeName
        {
            case "Bool":
                return BooleanCell.CellHeight
                
            case "Int":
                return IntCell.CellHeight
                
            case "Double":
                return DoubleCell.CellHeight
                
            case "CGFloat":
                return CGFloatCell.CellHeight
                
            case "UIColor":
                return ColorCell.CellHeight
                
            case "String":
                return StringCell.CellHeight
                
            case "ShapeCategories", "Shapes", "Backgrounds", "ShapeAlignments":
                return EnumCell.CellHeight
                
            default:
                return 10
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return HeaderHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return CurrentShapeOptions?.SettingItemList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let SettingSource = CurrentShapeOptions
        {
            let BGIndex = indexPath.row.isMultiple(of: 2) ? 0 : 1
            let BGColor = [UIColor(named: "OptionsColor0"), UIColor(named: "OptionsColor1")][BGIndex]
            let Cell = SettingSource.SettingItemList[indexPath.row].GenerateCell(With: tableView.frame.width)
            Cell?.backgroundColor = BGColor
            return Cell!
        }
        return UITableViewCell()
    }
}
