//
//  TriangleSettingSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/21/21.
//

import Foundation
import UIKit

class TriangleSettingSlice: UIViewController, UITextFieldDelegate,
                             SettingChangedProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
        
        Settings.AddSubscriber(self)
        let VWidth = Settings.GetInt(.ViewportWidth, IfZero: 1024)
        let VHeight = Settings.GetInt(.ViewportHeight, IfZero: 1024)
        let VSizeString = "\(VWidth) x \(VHeight)"
        ViewportSizeLabel.text = VSizeString
        
        let TriangleBase = Settings.GetDoubleNormal(.TriangleBase)
        let TMRectWidth = TriangleBase * 100.0
        let TMRectWidthString = "\(Int(TMRectWidth))"
        WidthTextField.text = TMRectWidthString
        WidthSlider.value = Float(TriangleBase * 1000.0)
        
        let TriangleHeight = Settings.GetDouble(.RectangleHeight, 0.95)
        let TMRectHeight = TriangleHeight * 100.0
        let TMRectHeightString = "\(Int(TMRectHeight))"
        HeightTextField.text = TMRectHeightString
        HeightSlider.value = Float(TriangleHeight * 1000.0)
        
        RoundedCornersSwitch.isOn = Settings.GetBool(.RectangleRoundedCorners)
        
        WidthTextField.delegate = self
        HeightTextField.delegate = self
        
        self.WidthTextField.addTarget(self, action: #selector(onWidthMajor),
                                      for: UIControl.Event.editingDidEndOnExit)
        self.HeightTextField.addTarget(self, action: #selector(onHeightMinor),
                                       for: UIControl.Event.editingDidEndOnExit)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HandleCloseTap))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        Settings.RemoveSubscriber(self)
        super.viewWillDisappear(animated)
    }
    
    @objc func HandleCloseTap()
    {
        WidthTextField.resignFirstResponder() // dismiss keyoard
        HeightTextField.resignFirstResponder() // dismiss keyoard
    }
    
    @IBAction func onWidthMajor()
    {
        self.WidthTextField.resignFirstResponder()
    }
    
    @IBAction func onHeightMinor()
    {
        self.HeightTextField.resignFirstResponder()
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
            var DValue = Double(IValue) * 0.01
            if textField == WidthTextField
            {
                Settings.SetDoubleNormal(.TriangleBase, DValue)
                DValue = DValue * 1000.0
                WidthSlider.value = Float(DValue)
            }
            if textField == HeightTextField
            {
                Settings.SetDoubleNormal(.TriangleHeight, DValue)
                DValue = DValue * 1000.0
                HeightSlider.value = Float(DValue)
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
    
    // MARK: - Interface builder actions
    
    @IBAction func RoundedCornersChangedHandler(_ sender: Any)
    {
        guard let Switch = sender as? UISwitch else
        {
            return
        }
        Settings.SetBool(.TriangleRounded, Switch.isOn)
    }
    
    @IBAction func WidthSliderChangeHandler(_ sender: Any)
    {
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Width slider change handler received non-slider control.")
        }
        var NewWidthValue = Double(Slider.value)
        NewWidthValue = NewWidthValue / 1000.0
        Settings.SetDoubleNormal(.TriangleBase, NewWidthValue)
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
        Settings.SetDoubleNormal(.TriangleHeight, NewHeightValue)
        let IHeight = Int(NewHeightValue * 100.0)
        let HeightString = "\(Int(IHeight))"
        HeightTextField.text = HeightString
    }
    
    // MARK: - Interface builder outlets
    
    @IBOutlet weak var WidthSlider: UISlider!
    @IBOutlet weak var HeightSlider: UISlider!
    @IBOutlet weak var HeightTextField: UITextField!
    @IBOutlet weak var WidthTextField: UITextField!
    @IBOutlet weak var RoundedCornersSwitch: UISwitch!
    @IBOutlet weak var ViewportSizeLabel: UILabel!
}
