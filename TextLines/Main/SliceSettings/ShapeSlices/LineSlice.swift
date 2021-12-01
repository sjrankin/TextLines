//
//  LineSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/24/21.
//

import Foundation
import UIKit

class LineSlice: UIViewController, UITextFieldDelegate, UIPickerViewDelegate,
                 UIPickerViewDataSource, SettingChangedProtocol, ShapeSliceProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
        
        LineTypePicker.layer.cornerRadius = UIConstants.CornerRadius
        LineTypePicker.layer.borderColor = UIConstants.DarkBorder
        LineTypePicker.layer.borderWidth = UIConstants.MediumBorder
        
        Settings.AddSubscriber(self)

        let Length = Settings.GetDouble(.LineLength, 0.95)
        let TLength = Length * 100.0
        let LengthString = "\(Int(TLength))"
        ExtentText.text = LengthString
        ExtentSlider.value = Float(Length * 1000.0)
        
        ExtentText.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HandleDismissTap))
        view.addGestureRecognizer(tap)
        
        //https://stackoverflow.com/questions/11553396/how-to-add-an-action-on-uitextfield-return-key
        self.ExtentText.addTarget(self, action: #selector(OnReturn), for: UIControl.Event.editingDidEndOnExit)
        
        let Orientation = Settings.GetEnum(ForKey: .LineType, EnumType: LineOptions.self, Default: .Horizontal)
        if let OrientationIndex = Lines.firstIndex(of: Orientation)
        {
            LineTypePicker.selectRow(OrientationIndex, inComponent: 0, animated: true)
        }
        else
        {
            LineTypePicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    let Lines: [LineOptions] =
    [
        .Horizontal,
        .Vertical,
        .DiagonalAscending,
        .DiagonalDescending
    ]
    
    @IBAction func OnReturn()
    {
        self.ExtentText.resignFirstResponder()
    }
    
    @objc func HandleDismissTap()
    {
        ExtentText.resignFirstResponder() // dismiss keyoard
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        Settings.RemoveSubscriber(self)
        super.viewWillDisappear(animated)
    }
    
    let ClassSubscriberID = UUID()
    
    func SubscriberID() -> UUID
    {
        return ClassSubscriberID
    }
    
    func SettingChanged(Setting: SettingKeys, OldValue: Any?, NewValue: Any?)
    {
        switch Setting
        {
            default:
                break
        }
    }
    
    // MARK: - Interface functions.
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        guard let Raw = textField.text else
        {
            Debug.Print("No text to parse.")
            return
        }
        let Pure = Raw.filter("0123456789".contains)
        if var IValue = Int(Pure)
        {
            if IValue < 0
            {
                IValue = 0
                textField.text = "0"
            }
            if IValue > 100
            {
                IValue = 100
                textField.text = "100"
            }
            var DValue = Double(IValue) * 0.01
            Settings.SetDoubleNormal(.LineLength, DValue)
            DValue = DValue * 1000.0
            ExtentSlider.value = Float(DValue)
        }
        else
        {
            Debug.Print("Error converting \"\(Pure)\" to Int.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func ExtentSliderChanged(_ sender: Any)
    {
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Slider change handler received non-slider control.")
        }
        var NewExtentValue = Double(Slider.value)
        NewExtentValue = NewExtentValue / 1000.0
        Settings.SetDouble(.LineLength, NewExtentValue)
        let IRadial = Int(NewExtentValue * 100.0)
        let RadiusString = "\(Int(IRadial))"
        ExtentText.text = RadiusString
    }
    
    func InitializeLinePicker()
    {
        LineTypePicker.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let SelectedType = Lines[row]
        Settings.SetEnum(SelectedType, EnumType: LineOptions.self, ForKey: .LineType)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String?
    {
        switch row
        {
            case 0:
                return "Horizontal Line"
                
            case 1:
                return "Vertical Line"
                
            case 2:
                return "Diagonal Line Ascending"
                
            case 3:
                return "Diagonal Line Descending"
                
            default:
                Debug.FatalError("Only four line types known - encountered \(row)")
        }
    }
    
    func ResetSettings()
    {
    }
    
    @IBOutlet weak var LineTypePicker: UIPickerView!
    @IBOutlet weak var ExtentText: UITextField!
    @IBOutlet weak var ExtentSlider: UISlider!
}
