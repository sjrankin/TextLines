//
//  StarSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 12/2/21.
//

import Foundation
import UIKit

class StarSlice: UIViewController, UITextFieldDelegate,
                         SettingChangedProtocol, ShapeSliceProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
        
        Settings.AddSubscriber(self)
        
        let NGWidth = Settings.GetDoubleNormal(.StarInnerRadius)
        let TMRectWidth = NGWidth * 100.0
        let TMRectWidthString = "\(Int(TMRectWidth))"
        InnerTextField.text = TMRectWidthString
        InnerSlider.value = Float(NGWidth * 1000.0)
        
        let NGHeight = Settings.GetDoubleNormal(.StarOuterRadius)
        let TMRectHeight = NGHeight * 100.0
        let TMRectHeightString = "\(Int(TMRectHeight))"
        OuterTextField.text = TMRectHeightString
        OuterSlider.value = Float(NGHeight * 1000.0)
        
        let NGRot = Settings.GetDouble(.StarRotation)
        let NTRotString = "\(Int(NGRot))"
        RotationField.text = NTRotString
        RotationSlider.value = Float(NGRot)
        
        let NGVertex = Settings.GetInt(.StarVertexCount)
        VertexCountField.text = "\(NGVertex)"
        VertexCountSlider.value = Float(NGVertex)
        
        SmoothSwitch.isOn = Settings.GetBool(.StarDrawSmooth)
        
        InnerTextField.delegate = self
        OuterTextField.delegate = self
        VertexCountField.delegate = self
        RotationField.delegate = self
        
        self.InnerTextField.addTarget(self, action: #selector(OnWidthDone),
                                      for: UIControl.Event.editingDidEndOnExit)
        self.OuterTextField.addTarget(self, action: #selector(OnHeightDone),
                                       for: UIControl.Event.editingDidEndOnExit)
        self.VertexCountField.addTarget(self, action: #selector(OnVertexDone),
                                        for: UIControl.Event.editingDidEndOnExit)
        self.RotationField.addTarget(self, action: #selector(OnRotationDone),
                                     for: UIControl.Event.editingDidEndOnExit)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HandleCloseTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func HandleCloseTap()
    {
        InnerTextField.resignFirstResponder()
        OuterTextField.resignFirstResponder()
        VertexCountField.resignFirstResponder()
        RotationField.resignFirstResponder()
    }
    
    @IBAction func OnWidthDone()
    {
        self.InnerTextField.resignFirstResponder()
    }
    
    @IBAction func OnHeightDone()
    {
        self.OuterTextField.resignFirstResponder()
    }
    
    @IBAction func OnVertexDone()
    {
        self.VertexCountField.resignFirstResponder()
    }
    
    @IBAction func OnRotationDone()
    {
        self.RotationField.resignFirstResponder()
    }
    
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
            switch textField
            {
                case InnerTextField:
                    var DValue = Double(IValue) * 0.01
                    Settings.SetDoubleNormal(.StarInnerRadius, DValue)
                    DValue = DValue * 1000.0
                    InnerSlider.value = Float(DValue)
                    
                case OuterTextField:
                    var DValue = Double(IValue) * 0.01
                    Settings.SetDoubleNormal(.StarOuterRadius, DValue)
                    DValue = DValue * 1000.0
                    OuterSlider.value = Float(DValue)
                    
                case VertexCountField:
                    Settings.SetInt(.StarVertexCount, IValue)
                    VertexCountSlider.value = Float(IValue)
                    
                case RotationField:
                    var DValue = Double(IValue)
                    Settings.SetDouble(.StarRotation, DValue)
                    DValue = DValue * 10.0
                    RotationSlider.value = Float(DValue)
                    
                default:
                    Debug.FatalError("Unexpected text field encountered.")
            }
        }
        else
        {
            Debug.Print("Error converting \"\(Pure)\" to Int.")
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Settings handling.
    
    var SettingID = UUID()
    
    func SubscriberID() -> UUID
    {
        return SettingID
    }
    
    func SettingChanged(Setting: SettingKeys, OldValue: Any?, NewValue: Any?)
    {
    }
    
    @IBAction func WidthSliderChangeHandler(_ sender: Any)
    {
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Width slider change handler received non-slider control.")
        }
        var NewWidthValue = Double(Slider.value)
        NewWidthValue = NewWidthValue / 1000.0
        Settings.SetDoubleNormal(.StarInnerRadius, NewWidthValue)
        let IWidth = Int(NewWidthValue * 100.0)
        let WidthString = "\(Int(IWidth))"
        InnerTextField.text = WidthString
    }
    
    @IBAction func HeightSliderChangeHandler(_ sender: Any)
    {
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Height slider change handler received non-slider control.")
        }
        var NewHeightValue = Double(Slider.value)
        NewHeightValue = NewHeightValue / 1000.0
        Settings.SetDoubleNormal(.StarOuterRadius, NewHeightValue)
        let IHeight = Int(NewHeightValue * 100.0)
        let HeightString = "\(Int(IHeight))"
        OuterTextField.text = HeightString
    }
    
    @IBAction func VertexSliderChanged(_ sender: Any)
    {
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Vertex slider change handler received non-slider control.")
        }
        var NewVertexCount = Int(Slider.value)
        Settings.SetInt(.StarVertexCount, NewVertexCount)
        VertexCountField.text = "\(NewVertexCount)"
    }
    
    @IBAction func RotationSliderChanged(_ sender: Any)
    {
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Rotation slider change handler received non-slider control.")
        }
        let NewRotateValue = Double(Slider.value)
        Settings.SetDouble(.StarRotation, NewRotateValue)
        let IRotate = Int(NewRotateValue)
        let RotateString = "\(Int(IRotate))"
        RotationField.text = RotateString
    }
    
    @IBAction func SmoothSwitchChangeHandler(_ sender: Any)
    {
        guard let Switch = sender as? UISwitch else
        {
            Debug.Print("Incorrect class sent to SmoothSwitchChangeHandler")
            return
        }
        Settings.SetBool(.StarDrawSmooth, Switch.isOn)
    }
    
    func InitializeTextField(_ Field: UITextField, Key: SettingKeys, Multiplier: Double = 10.0)
    {
        var Value = Settings.GetDouble(Key)
        Value = Value * Multiplier
        let DValue = Double(Value).RoundedTo(2)
        Field.text = "\(DValue)"
    }
    
    func InitializeSlider(_ Slider: UISlider, Key: SettingKeys, Multiplier: Double = 1000.0)
    {
        let Value = Settings.GetDouble(Key)
        let DValue = Value * Multiplier
        Slider.value = Float(DValue)
    }
    
    func ResetSettings()
    {
        Settings.SetIntDefault(For: .StarVertexCount)
        Settings.SetDoubleDefault(For: .StarRotation)
        Settings.SetDoubleDefault(For: .StarInnerRadius)
        Settings.SetDoubleDefault(For: .StarOuterRadius)
        InitializeTextField(InnerTextField, Key: .StarInnerRadius)
        InitializeTextField(OuterTextField, Key: .StarOuterRadius)
        InitializeTextField(RotationField, Key: .StarRotation, Multiplier: 1.0)
        let IVal = Settings.GetInt(.StarVertexCount)
        VertexCountField.text = "\(IVal)"
        VertexCountSlider.value = Float(IVal)
        InitializeSlider(RotationSlider, Key: .StarRotation, Multiplier: 1.0)
        InitializeSlider(InnerSlider, Key: .StarInnerRadius)
        InitializeSlider(OuterSlider, Key: .StarOuterRadius)
        Settings.SetBoolDefault(For: .StarDrawSmooth)
        SmoothSwitch.isOn = Settings.GetBool(.StarDrawSmooth)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        RotationField.resignFirstResponder()
        VertexCountField.resignFirstResponder()
        InnerTextField.resignFirstResponder()
        OuterTextField.resignFirstResponder()
        super.viewWillDisappear(animated)
    }

    @IBOutlet weak var SmoothSwitch: UISwitch!
    @IBOutlet weak var RotationSlider: UISlider!
    @IBOutlet weak var VertexCountSlider: UISlider!
    @IBOutlet weak var RotationField: UITextField!
    @IBOutlet weak var VertexCountField: UITextField!
    @IBOutlet weak var InnerSlider: UISlider!
    @IBOutlet weak var OuterSlider: UISlider!
    @IBOutlet weak var OuterTextField: UITextField!
    @IBOutlet weak var InnerTextField: UITextField!
}
