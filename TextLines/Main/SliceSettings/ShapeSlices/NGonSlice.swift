//
//  NGonSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 12/1/21.
//

import Foundation
import UIKit

class NGonSliceSettings: UIViewController, UITextFieldDelegate,
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
        
        let NGWidth = Settings.GetDoubleNormal(.NGonWidth)
        let TMRectWidth = NGWidth * 100.0
        let TMRectWidthString = "\(Int(TMRectWidth))"
        WidthTextField.text = TMRectWidthString
        WidthSlider.value = Float(NGWidth * 1000.0)
        
        let NGHeight = Settings.GetDoubleNormal(.NGonHeight)
        let TMRectHeight = NGHeight * 100.0
        let TMRectHeightString = "\(Int(TMRectHeight))"
        HeightTextField.text = TMRectHeightString
        HeightSlider.value = Float(NGHeight * 1000.0)
        
        let NGRot = Settings.GetDouble(.NGonRotation)
        let NTRotString = "\(Int(NGRot))"
        RotationField.text = NTRotString
        RotationSlider.value = Float(NGRot)
        
        let NGVertex = Settings.GetInt(.NGonVertexCount)
        VertexCountField.text = "\(NGVertex)"
        VertexCountSlider.value = Float(NGVertex)
        
        WidthTextField.delegate = self
        HeightTextField.delegate = self
        VertexCountField.delegate = self
        RotationField.delegate = self
        
        self.WidthTextField.addTarget(self, action: #selector(OnWidthDone),
                                      for: UIControl.Event.editingDidEndOnExit)
        self.HeightTextField.addTarget(self, action: #selector(OnHeightDone),
                                       for: UIControl.Event.editingDidEndOnExit)
        self.VertexCountField.addTarget(self, action: #selector(OnVertexDone),
                                       for: UIControl.Event.editingDidEndOnExit)
        self.RotationField.addTarget(self, action: #selector(OnRotationDone),
                                       for: UIControl.Event.editingDidEndOnExit)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HandleCloseTap))
        view.addGestureRecognizer(tap)
        
        SmoothDrawSwitch.isOn = Settings.GetBool(.NGonDrawSmooth)
    }
    
    @objc func HandleCloseTap()
    {
        WidthTextField.resignFirstResponder()
        HeightTextField.resignFirstResponder()
        VertexCountField.resignFirstResponder()
        RotationField.resignFirstResponder()
    }
    
    @IBAction func OnWidthDone()
    {
        self.WidthTextField.resignFirstResponder()
    }
    
    @IBAction func OnHeightDone()
    {
        self.HeightTextField.resignFirstResponder()
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
                case WidthTextField:
                    var DValue = Double(IValue) * 0.01
                    Settings.SetDoubleNormal(.NGonWidth, DValue)
                    DValue = DValue * 1000.0
                    WidthSlider.value = Float(DValue)
                    
                case HeightTextField:
                    var DValue = Double(IValue) * 0.01
                    Settings.SetDoubleNormal(.NGonWidth, DValue)
                    DValue = DValue * 1000.0
                    HeightSlider.value = Float(DValue)
                    
                case VertexCountField:
                    Settings.SetInt(.NGonVertexCount, IValue)
                    VertexCountSlider.value = Float(IValue)
                    
                case RotationField:
                    var DValue = Double(IValue)
                    Settings.SetDouble(.NGonRotation, DValue)
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
        Settings.SetDoubleNormal(.NGonWidth, NewWidthValue)
        let IWidth = Int(NewWidthValue * 100.0)
        let WidthString = "\(Int(IWidth))"
        WidthTextField.text = WidthString
    }
    
    @IBAction func HeightSliderChangeHandler(_ sender: Any)
    {
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Height slider change handler received non-slider control.")
        }
        var NewHeightValue = Double(Slider.value)
        NewHeightValue = NewHeightValue / 1000.0
        Settings.SetDoubleNormal(.NGonHeight, NewHeightValue)
        let IHeight = Int(NewHeightValue * 100.0)
        let HeightString = "\(Int(IHeight))"
        HeightTextField.text = HeightString
    }
    
    @IBAction func VertexSliderChanged(_ sender: Any)
    {
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Vertex slider change handler received non-slider control.")
        }
        var NewVertexCount = Int(Slider.value)
        Settings.SetInt(.NGonVertexCount, NewVertexCount)
        VertexCountField.text = "\(NewVertexCount)"
    }
    
    @IBAction func RotationSliderChanged(_ sender: Any)
    {
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Rotation slider change handler received non-slider control.")
        }
        let NewRotateValue = Double(Slider.value)
        Settings.SetDouble(.NGonRotation, NewRotateValue)
        let IRotate = Int(NewRotateValue)
        let RotateString = "\(Int(IRotate))"
        RotationField.text = RotateString
    }
    
    @IBAction func SmoothDrawChangedHandler(_ sender: Any)
    {
        guard let Switch = sender as? UISwitch else
        {
            Debug.Print("Incorrect class sent to SmoothDrawChangedHandler")
            return
        }
        Settings.SetBool(.NGonDrawSmooth, Switch.isOn)
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
        Settings.SetIntDefault(For: .NGonVertexCount)
        Settings.SetDoubleDefault(For: .NGonRotation)
        Settings.SetDoubleDefault(For: .NGonWidth)
        Settings.SetDoubleDefault(For: .NGonHeight)
        InitializeTextField(WidthTextField, Key: .NGonWidth)
        InitializeTextField(HeightTextField, Key: .NGonHeight)
        InitializeTextField(RotationField, Key: .NGonRotation, Multiplier: 1.0)
        let IVal = Settings.GetInt(.NGonVertexCount)
        VertexCountField.text = "\(IVal)"
        VertexCountSlider.value = Float(IVal)
        InitializeSlider(RotationSlider, Key: .NGonRotation, Multiplier: 1.0)
        InitializeSlider(WidthSlider, Key: .NGonWidth)
        InitializeSlider(HeightSlider, Key: .NGonHeight)
        Settings.SetBoolDefault(For: .NGonDrawSmooth)
        SmoothDrawSwitch.isOn = Settings.GetBool(.NGonDrawSmooth)
    }
    
    @IBOutlet weak var SmoothDrawSwitch: UISwitch!
    @IBOutlet weak var RotationSlider: UISlider!
    @IBOutlet weak var VertexCountSlider: UISlider!
    @IBOutlet weak var RotationField: UITextField!
    @IBOutlet weak var VertexCountField: UITextField!
    @IBOutlet weak var WidthSlider: UISlider!
    @IBOutlet weak var HeightSlider: UISlider!
    @IBOutlet weak var HeightTextField: UITextField!
    @IBOutlet weak var WidthTextField: UITextField!
}
