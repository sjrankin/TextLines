//
//  ArrayCell.swift
//  TextLine
//
//  Created by Stuart Rankin on 10/3/21.
//

import Foundation
import UIKit

typealias ArraySelector = (Int) -> ()

class ArrayCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource,
                 CellProtocol
{
    func SetWidth(_ Width: CGFloat)
    {
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        ArrayPicker.frame = CGRect(x: CurrentWidth - (PickerWidth + 10),
                                   y: EnumCell.CellHeight / 2 - 85 / 2,
                                   width: PickerWidth, height: 85)
        AdjustedWidth = Width
    }
    
    var AdjustedWidth: CGFloat = 0.0
    
    func SelectCurrentValue(_ Value: String)
    {
        if let Index = RawArrayData.firstIndex(of: Value)
        {
            ArrayPicker.selectRow(Index, inComponent: 0, animated: true)
        }
    }
    
    var RawArrayData: [String] = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return RawArrayData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return RawArrayData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        ArraySelectorClosure?(row)
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
        ArrayPicker = UIPickerView(frame: CGRect(x: CurrentWidth - (PickerWidth + 10),
                                                 y: EnumCell.CellHeight / 2 - 95 / 2,
                                                 width: PickerWidth, height: 95))
        ArrayPicker.delegate = self
        ArrayPicker.dataSource = self
        ArrayPicker.layer.borderWidth = 0.5
        ArrayPicker.layer.borderColor = UIColor.gray.cgColor
        ArrayPicker.layer.cornerRadius = 5.0
        contentView.addSubview(HeaderLabel)
        contentView.addSubview(ArrayPicker)
    }
    
    public static var CellHeight: CGFloat
    {
        get
        {
            return 110
        }
    }
    
    let PickerWidth: CGFloat = 180
    
    func LoadCell(ArrayData: [String], SelectedValue: String, Header: String, Width: CGFloat,
                  Closure: ArraySelector? = nil)
    {
        InitialSelectedValue = SelectedValue
        ArraySelectorClosure = Closure
        HeaderLabel.text = Header
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        ArrayPicker.frame = CGRect(x: CurrentWidth - (PickerWidth + 10),
                                   y: EnumCell.CellHeight / 2 - 85 / 2,
                                   width: PickerWidth, height: 85)
        ArrayPicker.reloadAllComponents()
        SelectCurrentValue(SelectedValue)
    }
    
    var InitialSelectedValue: String = ""
    var HeaderLabel: UILabel!
    var ArrayPicker: UIPickerView!
    var ArraySelectorClosure: ArraySelector? = nil
    var Setting: SettingKeys? = nil
    var CurrentWidth: CGFloat = 0.0
    var Header: String = ""
}
