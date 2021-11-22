//
//  OvalSettingSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/8/21.
//

import Foundation
import UIKit

class OvalSettingSlice: UIViewController, UITextFieldDelegate,
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
        CurrentViewportSize.text = VSizeString
        
        let MajorRadius = Settings.GetDouble(.EllipseMajor, 0.95)
        let TMjRadius = MajorRadius * 100.0
        let MjRadiusString = "\(Int(TMjRadius))"
        MajorRadialText.text = MjRadiusString
        MajorRadialSlider.value = Float(MajorRadius * 1000.0)
        
        let MinorRadius = Settings.GetDouble(.EllipseMinor, 0.95)
        let TMnRadius = MinorRadius * 100.0
        let MnRadiusString = "\(Int(TMnRadius))"
        MinorRadialText.text = MnRadiusString
        MinorRadialSlider.value = Float(MinorRadius * 1000.0)
        
        MajorRadialText.delegate = self
        MinorRadialText.delegate = self
        
        InitializeKeyboard()
        
        self.MajorRadialText.addTarget(self, action: #selector(onReturnMajor),
                                       for: UIControl.Event.editingDidEndOnExit)
        self.MinorRadialText.addTarget(self, action: #selector(onReturnMinor),
                                       for: UIControl.Event.editingDidEndOnExit)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap()
    {
        MajorRadialText.resignFirstResponder() // dismiss keyoard
        MinorRadialText.resignFirstResponder() // dismiss keyoard
    }
    
    @IBAction func onReturnMajor()
    {
        self.MajorRadialText.resignFirstResponder()
    }
    
    @IBAction func onReturnMinor()
    {
        self.MinorRadialText.resignFirstResponder()
    }
    
    /// Initialize the keyboard with a `Dismiss` button in a toolbar. This provides an alternative
    /// way for the user to indicate no more editing.
    func InitializeKeyboard()
    {
        let KBToolbar = UIToolbar()
        let FlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let DoneButton = UIBarButtonItem(title: "Dismiss", style: .done,
                                         target: self, action: #selector(KeyboardDoneButtonTapped))
        
        KBToolbar.setItems([FlexSpace, DoneButton], animated: true)
        KBToolbar.sizeToFit()
        MajorRadialText.inputAccessoryView = KBToolbar
        MinorRadialText.inputAccessoryView = KBToolbar
    }
    
    /// Called by the `Dismiss` button the program inserted into the keyboard's toolbar when the
    /// user has completed text entry.
    @objc func KeyboardDoneButtonTapped()
    {
        self.view.endEditing(true)
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
            case .ViewportWidth:
                let VWidth = Settings.GetInt(.ViewportWidth, IfZero: 1024)
                let VHeight = Settings.GetInt(.ViewportHeight, IfZero: 1024)
                let VSizeString = "\(VWidth) x \(VHeight)"
                CurrentViewportSize.text = VSizeString
                
            case .ViewportHeight:
                let VWidth = Settings.GetInt(.ViewportWidth, IfZero: 1024)
                let VHeight = Settings.GetInt(.ViewportHeight, IfZero: 1024)
                let VSizeString = "\(VWidth) x \(VHeight)"
                CurrentViewportSize.text = VSizeString
                
            default:
                break
        }
    }
    
    @IBAction func ViewportSizeButtonPressed(_ sender: Any)
    {
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
            if textField == MajorRadialText
            {
                Settings.SetDouble(.EllipseMajor, DValue)
                DValue = DValue * 1000.0
                MajorRadialSlider.value = Float(DValue)
            }
            if textField == MinorRadialText
            {
                Settings.SetDouble(.EllipseMinor, DValue)
                DValue = DValue * 1000.0
                MinorRadialSlider.value = Float(DValue)
            }
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
    
    @IBAction func RadialSliderChanged(_ sender: Any)
    {
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Major radial slider change handler received non-slider control.")
        }
        switch Slider
        {
            case MajorRadialText:
                var NewRadialValue = Double(Slider.value)
                NewRadialValue = NewRadialValue / 1000.0
                Settings.SetDouble(.EllipseMajor, NewRadialValue)
                let IRadial = Int(NewRadialValue * 100.0)
                let RadiusString = "\(Int(IRadial))"
                MajorRadialText.text = RadiusString
                
            case MinorRadialText:
                var NewRadialValue = Double(Slider.value)
                NewRadialValue = NewRadialValue / 1000.0
                Settings.SetDouble(.EllipseMinor, NewRadialValue)
                let IRadial = Int(NewRadialValue * 100.0)
                let RadiusString = "\(Int(IRadial))"
                MinorRadialText.text = RadiusString
                
            default:
                break
        }
    }
    
    @IBOutlet weak var MajorRadialText: UITextField!
    @IBOutlet weak var MajorRadialSlider: UISlider!
    @IBOutlet weak var MinorRadialText: UITextField!
    @IBOutlet weak var MinorRadialSlider: UISlider!
    @IBOutlet weak var CurrentViewportSize: UILabel!
}
