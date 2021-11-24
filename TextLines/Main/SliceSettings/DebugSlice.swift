//
//  DebugSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/23/21.
//

import Foundation
import UIKit

class DebugSlice: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        CurrentSettingValue.text = ""
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
        
        SettingPicker.clipsToBounds = true
        SettingPicker.layer.cornerRadius = UIConstants.CornerRadius
        SettingPicker.layer.borderColor = UIConstants.DarkBorder
        SettingPicker.layer.borderWidth = UIConstants.BorderThickness
        
        for SomeSetting in SettingKeys.allCases
        {
            SettingTable.append(SomeSetting)
        }
        ShowGuidemarks.isOn = Settings.GetBool(.ShowGuideMarks)
        SettingPicker.reloadAllComponents()
    }
    
    var SettingTable: [SettingKeys] = [SettingKeys]()
    
    @IBAction func ShowGuidemarksChanged(_ sender: Any)
    {
        guard let Switch = sender as? UISwitch else
        {
            return
        }
        Settings.SetBool(.ShowGuideMarks, Switch.isOn)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return SettingKeys.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let SettingValue = SettingTable[row]
        let SettingName = SettingValue.rawValue
        let ContainerWidth = pickerView.frame.width
        let Label = UILabel(frame: CGRect(x: 5,
                                          y: 0,
                                          width: ContainerWidth - 5,
                                          height: 20))
        Label.text = SettingName
        return Label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let SettingValue = SettingTable[row]
        let Display = Settings.GetStringed(SettingValue)
        CurrentSettingValue.text = Display
    }
    
    @IBAction func SetDefaultButtonHandler(_ sender: Any)
    {
        let SelectedRow = SettingPicker.selectedRow(inComponent: 0)
        let SettingName = SettingTable[SelectedRow].rawValue
        print("Setting Row: \(SelectedRow) = \(SettingName)")
        Settings.SetDefault(For: SettingTable[SelectedRow])
        let Display = Settings.GetStringed(SettingTable[SelectedRow])
        CurrentSettingValue.text = Display
    }
    
    @IBOutlet weak var CurrentSettingValue: UILabel!
    @IBOutlet weak var SettingPicker: UIPickerView!
    @IBOutlet weak var ShowGuidemarks: UISwitch!
}
