//
//  +SettingPanel.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/16/21.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    @IBAction func SettingPanelDoneHandler(_ sender: Any)
    {
        TextInput.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: [.allowUserInteraction],
                       animations:
                        {
            self.SettingPanel.alpha = 0.0
        },
                       completion:
                        {
            _ in
            self.SettingPanel.resignFirstResponder()
            self.SettingPanel.layer.zPosition = -1000
        })
    }
    
    @IBAction func SettingPanelAllSettingsView(_ sender: Any)
    {
        let Storyboard = UIStoryboard(name: "SettingsUI", bundle: nil)
        let nextViewController = Storyboard.instantiateViewController(withIdentifier: "MainSettingUIController") as! MainSettingUIController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch tableView
        {
            case SettingPanelCommandTable:
                return 40
                
            case SettingOptionTable:
                if OptionGroup == 3 || OptionGroup == 5
                {
                    return SettingCellHeight
                }
                return 40
                
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch tableView
        {
            case SettingPanelCommandTable:
                return SettingCommands.count
                
            case SettingOptionTable:
                return SettingTableItemCount
                
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch tableView
        {
            case SettingPanelCommandTable:
                let Cell = UITableViewCell(style: .default, reuseIdentifier: "SettingTableCell")
                let ColorIndex = indexPath.row.isMultiple(of: 2) ? 0 : 1
                let BGColor = [UIColor(named: "OptionsColor0"), UIColor(named: "OptionsColor1")][ColorIndex]
                Cell.backgroundColor = BGColor
                var Config = Cell.defaultContentConfiguration()
                
                Config.text = SettingCommands[indexPath.row]
                Cell.contentConfiguration = Config
                return Cell
                
            case SettingOptionTable:
                if let Command = CommandSelected
                {
                    switch Command
                    {
                        case 0:
                            switch indexPath.row
                            {
                                case 0:
                                    let Cell = ButtonCell(style: .default, reuseIdentifier: "ButtonCell")
                                    Cell.LoadCell(Header: "Save image", Title: "Save", Width: tableView.frame.width)
                                    {
                                        self.TextOutput.image?.SaveInPhotoAlbum()
                                    }
                                    Cell.backgroundColor = UIColor(named: "OptionsColor0")
                                    return Cell
                                    
                                case 1:
                                    let Cell = ButtonCell(style: .default, reuseIdentifier: "ButtonCell")
                                    Cell.LoadCell(Header: "Share image", Title: "Share", Width: tableView.frame.width)
                                    {
                                        print("Share called")
                                    }
                                    Cell.backgroundColor = UIColor(named: "OptionsColor1")
                                    return Cell
                                    
                                default:
                                    return UITableViewCell()
                            }
                            
                        case 1:
                            let CurrentShape = Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
                            return MakeShapeAttributeCell(CurrentShape, indexPath.row)
                            
                        case 2:
                            let Cell = BooleanCell(style: .default, reuseIdentifier: "BooleanCell")
                            Cell.LoadCell(Setting: .RotateCharacters, Header: "Rotate text 180°", Width: tableView.frame.width)
                            return Cell
                            
                        case 3:
                            let Cell = SegmentCell(style: .default, reuseIdentifier: "SegmentCell")
                            Cell.LoadCell(Title: "Text alignments",
                                          Images:
                                            [
                                                UIImage(systemName: "slash.circle")!,
                                                UIImage(systemName: "arrow.up.circle")!,
                                                UIImage(systemName: "arrow.down.circle")!,
                                                UIImage(systemName: "arrow.backward.circle")!,
                                                UIImage(systemName: "arrow.forward.circle")!,
                                            ],
                                          Width: tableView.frame.width,
                                          InitialIndex: 1)
                            {
                                Index in
                                let FinalIndex = Index < 0 ? 0 : Index
                                let NewAlignment = ShapeAlignments.allCases[FinalIndex]
                                Settings.SetEnum(NewAlignment, EnumType: ShapeAlignments.self, ForKey: .ShapeAlignment)
                            }
                            return Cell
                            
                        case 4:
                            let Cell = BooleanCell(style: .default, reuseIdentifier: "BoolCell")
                            Cell.LoadCell(Setting: .Animating, Header: "Animate text", Width: tableView.frame.width)
                            {
                                IsOn in
                                self.SetAnimationState()
                                self.SetAnimationState2()
                            }
                            return Cell
                            
                        case 5:
                            let Cell = SegmentCell(style: .default, reuseIdentifier: "SegmentCell")
                            Cell.LoadCell(Title: "Animation velocity",
                                          Images:
                                            [
                                                UIImage(systemName: "tortoise.fill")!,
                                                UIImage(systemName: "tortoise")!,
                                                UIImage(systemName: "square.fill.and.line.vertical.square.fill")!,
                                                UIImage(systemName: "hare")!,
                                                UIImage(systemName: "hare.fill")!,
                                            ],
                                          Width: tableView.frame.width,
                                          InitialIndex: 3)
                            {
                                Index in
                                if Index >= 0 && Index < 5
                                {
                                    let Final = [1, 4, 8, 12, 16][Index]
                                    Settings.SetInt(.AnimationSpeed, Final)
                                }
                            }
                            return Cell
                            
                        case 6:
                            let Cell = ButtonCell(style: .default, reuseIdentifier: "ButtonCell")
                            Cell.LoadCell(Header: "Reset shape", Title: "Reset", Width: tableView.frame.width)
                            {
                                print("Reset called")
                            }
                            return Cell
                            
                        case 7:
                            let Cell = UITableViewCell(style: .value1, reuseIdentifier: "VersionCell")
                            var Config = Cell.defaultContentConfiguration()
                            switch indexPath.row
                            {
                                case 0:
                                    Config.text = "TextLine"
                                    Config.textProperties.font = UIFont.boldSystemFont(ofSize: 20.0)
                                    Cell.contentConfiguration = Config
                                    
                                case 1:
                                    Config.text = "Version"
                                    Config.secondaryText = Versioning.VerySimpleVersionString()
                                    Cell.contentConfiguration = Config
                                    
                                case 2:
                                    Config.text = "Build"
                                    Config.secondaryText = "\(Versioning.Build)"
                                    Cell.contentConfiguration = Config
                                    
                                case 3:
                                    Config.text = Versioning.CopyrightText()
                                    Config.textProperties.font = UIFont.systemFont(ofSize: 12.0)
                                    Cell.contentConfiguration = Config
                                    
                                default:
                                    return UITableViewCell()
                            }
                            return Cell
                            
                        case 8:
                            switch indexPath.row
                            {
                                case 0:
                                    let Cell = BooleanCell(style: .default, reuseIdentifier: "BoolCell")
                                    Cell.LoadCell(Setting: .ShowGuideMarks, Header: "Debug guides", Width: tableView.frame.width)
                                    Cell.backgroundColor = UIColor(named: "OptionsColor0")
                                    return Cell
                                    
                                case 1:
                                    let Cell = NavigationCell(style: .default, reuseIdentifier: "NavigationCell")
                                    Cell.LoadCell(Header: "Settings editor", Width: tableView.frame.width)
                                    {
                                        _ in
                                        let Storyboard = UIStoryboard(name: "DebugUI2", bundle: nil)
                                        let VC = Storyboard.instantiateViewController(withIdentifier: "SettingsEditor") as! SettingsEditor
                                        self.present(VC, animated: true, completion: nil)
                                    }
                                    return Cell
                                    
                                case 2:
                                    let Cell = ButtonCell(style: .default, reuseIdentifier: "ButtonCell")
                                    Cell.LoadCell(Header: "Reset settings", Title: "Reset", Width: tableView.frame.width)
                                    {
                                        print("Reset settings called")
                                        Settings.SetDefaultValues()
                                    }
                                    Cell.backgroundColor = UIColor(named: "OptionsColor0")
                                    return Cell
                                    
                                default:
                                    break
                            }
                            
                        default:
                            break
                    }
                }
                return UITableViewCell()
                
            default:
                return UITableViewCell()
        }
    }
    
    func MakeShapeAttributeCell(_ Shape: Shapes, _ Index: Int) -> UITableViewCell
    {
        let Width = SettingOptionTable.frame.width
        switch Shape
        {
            case .Circle:
                switch Index
                {
                    case 0:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.CircleDiameter]!,
                                                 With: Width,
                                                 SettingKey: .CircleDiameter,
                                                 DoubleVisible: nil,
                                                 DoubleSave: nil,
                                                 CGFloatVisible: nil,
                                                 CGFloatSave: nil)!
                    default:
                        break
                }
                
            case .Ellipse:
                switch Index
                {
                    case 0:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.EllipseLength]!,
                                                        With: Width,
                                                        SettingKey: .EllipseLength,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    case 1:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.EllipseHeight]!,
                                                        With: Width,
                                                        SettingKey: .EllipseHeight,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    default:
                        break
                }
                
            case .Rectangle:
                switch Index
                {
                    case 0:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.RectangleWidth]!,
                                                        With: Width,
                                                        SettingKey: .RectangleWidth,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    case 1:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.RectangleWidth]!,
                                                        With: Width,
                                                        SettingKey: .RectangleWidth,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    case 2:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.RectangleRoundedCorners]!,
                                                        With: Width,
                                                        SettingKey: .RectangleRoundedCorners,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    default:
                        break
                }
                
            case .Triangle:
                switch Index
                {
                    case 0:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.TriangleBase]!,
                                                        With: Width,
                                                        SettingKey: .TriangleBase,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    case 1:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.TriangleHeight]!,
                                                        With: Width,
                                                        SettingKey: .TriangleHeight,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    case 2:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.TriangleRounded]!,
                                                        With: Width,
                                                        SettingKey: .TriangleRounded,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    default:
                        break
                }
                
            case .Line:
                switch Index
                {
                    case 0:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.LineLength]!,
                                                        With: Width,
                                                        SettingKey: .LineLength,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    case 1:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.LineType]!,
                                                        With: Width,
                                                        SettingKey: .LineType)!
                        
                    default:
                        break
                }
                
            case .Spiral:
                switch Index
                {
                    case 0:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.SpiralStartRadius]!,
                                                        With: Width,
                                                        SettingKey: .SpiralStartRadius,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    case 1:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.SpiralSpacePerLoop]!,
                                                        With: Width,
                                                        SettingKey: .SpiralSpacePerLoop,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    case 2:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.SpiralStartTheta]!,
                                                        With: Width,
                                                        SettingKey: .SpiralStartTheta,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    case 3:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.SpiralEndTheta]!,
                                                        With: Width,
                                                        SettingKey: .SpiralEndTheta,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    case 4:
                        return SettingItem.GenerateCell(Header: Settings.SettingKeyHeaders[.SpiralThetaStep]!,
                                                        With: Width,
                                                        SettingKey: .SpiralThetaStep,
                                                        DoubleVisible: nil,
                                                        DoubleSave: nil,
                                                        CGFloatVisible: nil,
                                                        CGFloatSave: nil)!
                        
                    default:
                        break
                }
                
            default:
                break
        }
        return UITableViewCell()
    }
    
    func ShapeSettingCount(For Shape: Shapes) -> Int
    {
        switch Shape
        {
            case .Circle:
                return 1
                
            case .Ellipse:
                return 2
                
            case .Rectangle:
                return 3
                
            case .Triangle:
                return 3
                
            case .Line:
                return 2
                
            case .Spiral:
                return 5
                
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch tableView
        {
            case SettingPanelCommandTable:
                CommandSelected = indexPath.row
                OptionGroup = CommandSelected!
                switch CommandSelected!
                {
                    case 0:
                        SettingTableItemCount = 2
                        SettingOptionTable.reloadData()
                        
                    case 1:
                        let Shape = Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
                        SettingTableItemCount = ShapeSettingCount(For: Shape)
                        SettingOptionTable.reloadData()
                        
                    case 2:
                        SettingTableItemCount = 1
                        SettingOptionTable.reloadData()
                        
                    case 3:
                        SettingCellHeight = SegmentCell.CellHeight
                        SettingTableItemCount = 1
                        SettingOptionTable.reloadData()
                        
                    case 4:
                        SettingTableItemCount = 1
                        SettingOptionTable.reloadData()
                        
                    case 5:
                        SettingCellHeight = SegmentCell.CellHeight
                        SettingTableItemCount = 1
                        SettingOptionTable.reloadData()
                        
                    case 6:
                        SettingTableItemCount = 1
                        SettingOptionTable.reloadData()
                        
                    case 7:
                        SettingTableItemCount = 4
                        SettingOptionTable.reloadData()
                        
                    case 8:
                        SettingTableItemCount = 4
                        SettingOptionTable.reloadData()
                        
                    default:
                        break
                }
                
            case SettingOptionTable:
                SettingCellHeight = 40
                if let Command = CommandSelected
                {
                    switch Command
                    {
                        case 0:
                            SettingOptionTable.reloadData()
                            
                        case 1:
                            break
                            
                        case 2:
                            SettingOptionTable.reloadData()
                            
                        case 3:
                            SettingCellHeight = SegmentCell.CellHeight
                            SettingOptionTable.reloadData()
                            
                        case 4:
                            SettingOptionTable.reloadData()
                            
                        case 5:
                            break
                            
                        case 6:
                            SettingOptionTable.reloadData()
                            
                        default:
                            break
                    }
                }
                
            default:
                return
        }
    }
}
