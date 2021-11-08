//
//  CircleSettingSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class CircleSettingSlice: UIViewController, UITextFieldDelegate,
                          SettingChangedProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 5.0
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.layer.borderWidth = 1.5
        
        Settings.AddSubscriber(self)
        let VWidth = Settings.GetInt(.ViewportWidth, IfZero: 1024)
        let VHeight = Settings.GetInt(.ViewportHeight, IfZero: 1024)
        let VSizeString = "\(VWidth) x \(VHeight)"
        CurrentViewportSize.text = VSizeString
        let Radius = Settings.GetDouble(.CircleRadiusPercent, 0.95)
        let TRadius = Radius * 100.0
        let RadiusString = "\(Int(TRadius))"
        RadialText.text = RadiusString
        RadialSlider.value = Float(Radius * 1000.0)
        
        RadialText.delegate = self
        
        InitializeKeyboard()
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
        RadialText.inputAccessoryView = KBToolbar
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
            print("DValue=\(DValue)")
            Settings.SetDouble(.CircleRadiusPercent, DValue)
            print("Stored DValue=\(Settings.GetDouble(.CircleRadiusPercent, -1.0))")
            DValue = DValue * 1000.0
            RadialSlider.value = Float(DValue)
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
        print("RadialSliderChanged")
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Slider change handler received non-slider control.")
        }
        var NewRadialValue = Double(Slider.value)
        NewRadialValue = NewRadialValue / 1000.0
        Settings.SetDouble(.CircleRadiusPercent, NewRadialValue)
        let IRadial = Int(NewRadialValue * 100.0)
        let RadiusString = "\(Int(IRadial))"
        RadialText.text = RadiusString
    }
    
    @IBOutlet weak var RadialText: UITextField!
    @IBOutlet weak var RadialSlider: UISlider!
    @IBOutlet weak var CurrentViewportSize: UILabel!
}
