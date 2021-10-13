//
//  AnimationUICode.swift
//  AnimationUICode
//
//  Created by Stuart Rankin on 8/31/21.
//

import Foundation
import UIKit

class AnimationUICode: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let Speed = Settings.GetInt(.AnimationSpeed, IfZero: 3) - 1
        VelocityPicker.reloadAllComponents()
        VelocityPicker.selectRow(Speed, inComponent: 0, animated: true)
        ClockwiseAnimationSwitch.isOn = Settings.GetBool(.AnimateClockwise)
    }
    
    @IBAction func ClockwiseAnimationChangedHandler(_ sender: Any)
    {
        if let Switch = sender as? UISwitch
        {
            Settings.SetBool(.AnimateClockwise, Switch.isOn)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        Settings.SetInt(.AnimationSpeed, row + 1)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return 16
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return "\(row + 1)x"
    }
    
    @IBOutlet weak var VelocityPicker: UIPickerView!
    @IBOutlet weak var ClockwiseAnimationSwitch: UISwitch!
}
