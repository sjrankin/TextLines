//
//  EnumCell.swift
//  EnumCell
//
//  Created by Stuart Rankin on 9/13/21.
//

import Foundation
import UIKit

class EnumCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource
{
    func GetEnumData(For Setting: SettingKeys)
    {
        switch Setting
        {
            case .MainShape:
                for SomeEnum in ShapeCategories.allCases
                {
                    RawEnumData.append(SomeEnum.rawValue)
                }
                
            case .CurrentShape:
                for SomeEnum in Shapes.allCases
                {
                    RawEnumData.append(SomeEnum.rawValue)
                }
                
            case .BackgroundType:
                for SomeEnum in Backgrounds.allCases
                {
                    RawEnumData.append(SomeEnum.rawValue)
                }
                
            case .ShapeAlignment:
                for SomeEnum in ShapeAlignments.allCases
                {
                    RawEnumData.append(SomeEnum.rawValue)
                }
                
            case .LineType:
                for SomeEnum in LineOptions.allCases
                {
                    RawEnumData.append(SomeEnum.rawValue)
                }
                
            case .LineStyle:
                for SomeEnum in LineStyles.allCases
                {
                    RawEnumData.append(SomeEnum.rawValue)
                }
                
            default:
                Debug.FatalError("Uncomprehended enum: \(Setting)")
        }
    }
    
    func SelectCurrentValue()
    {
        var Value: String = ""
        switch Setting!
        {
            case .MainShape:
                let Actual = Settings.GetEnum(ForKey: Setting!, EnumType: ShapeCategories.self)
                Value = Actual!.rawValue
                
            case .CurrentShape:
                let Actual = Settings.GetEnum(ForKey: Setting!, EnumType: Shapes.self)
                Value = Actual!.rawValue
                
            case .BackgroundType:
                let Actual = Settings.GetEnum(ForKey: Setting!, EnumType: Backgrounds.self)
                Value = Actual!.rawValue
                
            case .ShapeAlignment:
                let Actual = Settings.GetEnum(ForKey: Setting!, EnumType: ShapeAlignments.self)
                Value = Actual!.rawValue
                
            default:
                Debug.Print("Unexpected setting in EnumCell: \(Setting!)")
        }
        if let Index = RawEnumData.firstIndex(of: Value)
        {
            EnumPicker.selectRow(Index, inComponent: 0, animated: true)
        }
    }
    
    var RawEnumData: [String] = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return RawEnumData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return RawEnumData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let Raw = RawEnumData[row]
        switch Setting
        {
            case .ShapeAlignment:
                guard let Actual = ShapeAlignments(rawValue: Raw) else
                {
                    Debug.FatalError("\(Raw) is not a member of ShapeAlignments.")
                }
                Settings.SetEnum(Actual, EnumType: ShapeAlignments.self, ForKey: Setting!)
        
            case .MainShape:
                guard let Actual = ShapeCategories(rawValue: Raw) else
                {
                    Debug.FatalError("\(Raw) is not a member of ShapeCategories.")
                }
                Settings.SetEnum(Actual, EnumType: ShapeCategories.self, ForKey: Setting!)
                
            case .CurrentShape:
                guard let Actual = Shapes(rawValue: Raw) else
                {
                    Debug.FatalError("\(Raw) is not a member of Shapes.")
                }
                Settings.SetEnum(Actual, EnumType: Shapes.self, ForKey: Setting!)
                
            case .BackgroundType:
                guard let Actual = Backgrounds(rawValue: Raw) else
                {
                    Debug.FatalError("\(Raw) is not a member of Backgrounds.")
                }
                Settings.SetEnum(Actual, EnumType: Backgrounds.self, ForKey: Setting!)
                
            case .LineStyle:
                guard let Actual = LineStyles(rawValue: Raw) else
                {
                    Debug.FatalError("\(Raw) is not a member of LineStyles.")
                }
                Settings.SetEnum(Actual, EnumType: LineStyles.self, ForKey: Setting!)
                
            case .LineType:
                guard let Actual = LineOptions(rawValue: Raw) else
                {
                    Debug.FatalError("\(Raw) is not a member of LineOptions.")
                }
                Settings.SetEnum(Actual, EnumType: LineOptions.self, ForKey: Setting!)
                
            default:
                Debug.FatalError("Unexpected type in pickerView.didSelectRow.")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        InitializeUI()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    func InitializeUI()
    {
        self.selectionStyle = .none
        HeaderLabel = UILabel(frame: CGRect(x: 15, y: 5, width: 300, height: 30))
        HeaderLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        HeaderLabel.textColor = UIColor.black
        EnumPicker = UIPickerView(frame: CGRect(x: CurrentWidth - (PickerWidth + 10),
                                                y: EnumCell.CellHeight / 2 - 85 / 2,
                                                width: PickerWidth, height: 85))
        EnumPicker.delegate = self
        EnumPicker.dataSource = self
        EnumPicker.layer.borderWidth = 0.5
        EnumPicker.layer.borderColor = UIColor.gray.cgColor
        EnumPicker.layer.cornerRadius = 5.0
        contentView.addSubview(HeaderLabel)
        contentView.addSubview(EnumPicker)
    }
    
    public static var CellHeight: CGFloat
    {
        get
        {
            return 100
        }
    }
    
    let PickerWidth: CGFloat = 180
    
    func LoadCell(Setting: SettingKeys, Header: String, Width: CGFloat)
    {
        self.Setting = Setting
        HeaderLabel.text = Header
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        print("CurrentWidth = \(CurrentWidth)")
        EnumPicker.frame = CGRect(x: CurrentWidth - (PickerWidth + 10),
                                     y: EnumCell.CellHeight / 2 - 85 / 2,
                                     width: PickerWidth, height: 85)
        GetEnumData(For: Setting)
        EnumPicker.reloadAllComponents()
        SelectCurrentValue()
    }
    
    var HeaderLabel: UILabel!
    var EnumPicker: UIPickerView!
    
    var Setting: SettingKeys? = nil
    var CurrentWidth: CGFloat = 0.0
    var Header: String = ""
}
